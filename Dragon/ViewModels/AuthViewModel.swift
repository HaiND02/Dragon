import Foundation
import CoreData
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isNewUser = false
    
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
} 