import SwiftUI
import CoreData

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Đăng Ký")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Họ và tên", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if fullName.isEmpty && viewModel.showError {
                        Text("Vui lòng nhập họ tên")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    if !viewModel.isValidEmail(email) && !email.isEmpty {
                        Text("Email không hợp lệ")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Mật khẩu", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !viewModel.isValidPassword(password) && !password.isEmpty {
                        Text("Mật khẩu phải có ít nhất 6 ký tự")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Xác nhận mật khẩu", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if password != confirmPassword && !confirmPassword.isEmpty {
                        Text("Mật khẩu xác nhận không khớp")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Button(action: {
                    if password == confirmPassword {
                        viewModel.register(email: email, password: password, fullName: fullName)
                        if viewModel.isAuthenticated {
                            dismiss()
                        }
                    } else {
                        viewModel.errorMessage = "Mật khẩu xác nhận không khớp"
                        viewModel.showError = true
                    }
                }) {
                    Text("Đăng Ký")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
}