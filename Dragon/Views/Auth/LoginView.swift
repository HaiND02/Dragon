import SwiftUI
import CoreData

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Đăng Nhập")
                    .font(.largeTitle)
                    .bold()
                
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
                
                Button(action: {
                    viewModel.login(email: email, password: password)
                }) {
                    Text("Đăng Nhập")
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
                
                Button(action: {
                    showRegister = true
                }) {
                    Text("Chưa có tài khoản? Đăng ký ngay")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .sheet(isPresented: $showRegister) {
                RegisterView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 