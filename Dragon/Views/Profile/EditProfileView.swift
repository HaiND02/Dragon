import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var location: String = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Avatar Section
                    Button(action: { showImagePicker = true }) {
                        ZStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(AppColors.cardBackground, lineWidth: 2))
                            } else {
                                ProfileImage(viewModel: viewModel, user: viewModel.currentUser, size: 120)
                            }
                            
                            // Camera button overlay
                            Circle()
                                .fill(AppColors.primary)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                )
                                .offset(x: 45, y: 45)
                        }
                    }
                    .shadow(color: AppColors.cardShadow, radius: 10)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        FormField(
                            icon: "person.fill",
                            placeholder: "Họ và tên",
                            text: $fullName
                        )
                        
                        FormField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $email
                        )
                        .disabled(true)
                        .opacity(0.8)
                        
                        FormField(
                            icon: "phone.fill",
                            placeholder: "Số điện thoại",
                            text: $phone
                        )
                        
                        FormField(
                            icon: "location.fill",
                            placeholder: "Địa chỉ",
                            text: $location
                        )
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: saveChanges) {
                        Text("Lưu thay đổi")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.primary)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Chỉnh sửa thông tin")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") { dismiss() }
                }
            }
        }
        .onAppear(perform: loadUserData)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert("Thông báo", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadUserData() {
        if let user = viewModel.currentUser {
            fullName = user.fullName ?? ""
            email = user.email ?? ""
            phone = user.phone ?? ""
            location = user.location ?? ""
        }
    }
    
    private func saveChanges() {
        guard !fullName.isEmpty else {
            alertMessage = "Vui lòng nhập họ tên"
            showAlert = true
            return
        }
        
        viewModel.updateUserProfile(
            fullName: fullName,
            phone: phone,
            location: location,
            image: selectedImage
        )
        
        dismiss()
    }
}

// Form Field Component
struct FormField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .shadow(color: AppColors.cardShadow, radius: 5)
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
}

#Preview {
    EditProfileView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 