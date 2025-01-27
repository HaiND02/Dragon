import Foundation
import CoreData
import SwiftUI

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel(context: PersistenceController.shared.container.viewContext)
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isNewUser = false
    @Published private var userImages: [String: UIImage] = [:]
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        checkAuthStatus()
    }
    
    // MARK: - Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    // MARK: - Authentication Methods
    func register(email: String, password: String, fullName: String) {
        // Reset states
        showError = false
        errorMessage = ""
        isNewUser = false
        isAuthenticated = false
        currentUser = nil
        
        // Validate input
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty else {
            self.errorMessage = "Vui lòng điền đầy đủ thông tin"
            self.showError = true
            return
        }
        
        guard isValidEmail(email) else {
            self.errorMessage = "Email không hợp lệ"
            self.showError = true
            return
        }
        
        guard isValidPassword(password) else {
            self.errorMessage = "Mật khẩu phải có ít nhất 6 ký tự"
            self.showError = true
            return
        }
        
        // Check if email exists
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email.lowercased())
        
        do {
            let users = try context.fetch(fetchRequest)
            if !users.isEmpty {
                self.errorMessage = "Email đã tồn tại"
                self.showError = true
                return
            }
            
            // Create new user
            let user = User(context: context)
            user.email = email.lowercased()
            user.password = password
            user.fullName = fullName
            user.createdAt = Date()
            
            try context.save()
            
            // Save to UserDefaults
            UserDefaults.standard.set(user.email, forKey: "userEmail")
            UserDefaults.standard.synchronize()
            
            // Update states
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isNewUser = true
                print("Đăng ký thành công: \(user.fullName ?? "")")
            }
            
        } catch {
            print("Lỗi đăng ký: \(error)")
            self.errorMessage = "Đăng ký thất bại: \(error.localizedDescription)"
            self.showError = true
        }
    }
    
    func login(email: String, password: String) {
        // Reset states
        showError = false
        errorMessage = ""
        isNewUser = false
        isAuthenticated = false
        currentUser = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Vui lòng điền đầy đủ thông tin"
            self.showError = true
            return
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", 
                                           email.lowercased(), password)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                // Save to UserDefaults
                UserDefaults.standard.set(user.email, forKey: "userEmail")
                UserDefaults.standard.synchronize()
                
                // Update states
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                    print("Đăng nhập thành công: \(user.fullName ?? "")")
                }
            } else {
                self.errorMessage = "Email hoặc mật khẩu không đúng"
                self.showError = true
            }
        } catch {
            print("Lỗi đăng nhập: \(error)")
            self.errorMessage = "Đăng nhập thất bại: \(error.localizedDescription)"
            self.showError = true
        }
    }
    
    func logout() {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.synchronize()
        
        // Clear image cache when logging out
        clearAllImageCache()
        
        // Reset states
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isAuthenticated = false
            self.isNewUser = false
            print("Đã đăng xuất")
        }
    }
    
    // MARK: - Helper Methods
    private func checkAuthStatus() {
        if let email = UserDefaults.standard.string(forKey: "userEmail") {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let users = try context.fetch(fetchRequest)
                if let user = users.first {
                    DispatchQueue.main.async {
                        self.currentUser = user
                        self.isAuthenticated = true
                        print("Tự động đăng nhập: \(user.fullName ?? "")")
                    }
                }
            } catch {
                print("Lỗi kiểm tra trạng thái: \(error)")
            }
        }
    }
    
    func updateUserProfile(fullName: String, phone: String, location: String, image: UIImage?) {
        if let user = currentUser, let email = user.email {
            user.fullName = fullName
            user.phone = phone
            user.location = location
            
            if let image = image {
                // Lưu ảnh vào dictionary với key là email
                userImages[email] = image
                
                if let imageUrl = saveImageToFileManager(image: image, fileName: "\(email)_profile") {
                    user.avatarUrl = imageUrl.path
                }
            }
            
            do {
                try context.save()
                objectWillChange.send()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    private func saveImageToFileManager(image: UIImage, fileName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).jpg")
        
        do {
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadProfileImage(for user: User) -> UIImage? {
        guard let email = user.email else { return nil }
        
        // Kiểm tra trong memory cache trước
        if let cachedImage = userImages[email] {
            return cachedImage
        }
        
        // Nếu không có trong cache, load từ file system
        guard let avatarUrl = user.avatarUrl else { return nil }
        let url = URL(fileURLWithPath: avatarUrl)
        
        do {
            let imageData = try Data(contentsOf: url)
            if let image = UIImage(data: imageData) {
                // Cache lại ảnh vừa load được
                userImages[email] = image
                return image
            }
        } catch {
            print("Error loading image: \(error)")
        }
        return nil
    }
    
    func clearImageCache(for email: String) {
        userImages.removeValue(forKey: email)
    }
    
    func clearAllImageCache() {
        userImages.removeAll()
    }
} 