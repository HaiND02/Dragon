import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background gradient
            AppStyles.backgroundGradient(colorScheme: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                DragonLogoView(size: 120)
                    .padding(.top, 50)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                
                Text("Đăng Nhập")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(AppColors.text)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                VStack(spacing: 20) {
                    // Email field
                    TextInputView(text: $email, placeholder: "Email", icon: "envelope")
                        .padding(.horizontal)
                        .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width)
                    
                    if !viewModel.isValidEmail(email) && !email.isEmpty {
                        Text("Email không hợp lệ")
                            .foregroundColor(AppColors.error)
                            .font(.caption)
                    }
                    
                    // Password field
                    SecureInputView(text: $password, placeholder: "Mật khẩu")
                        .padding(.horizontal)
                        .offset(x: isAnimating ? 0 : UIScreen.main.bounds.width)
                    
                    if !viewModel.isValidPassword(password) && !password.isEmpty {
                        Text("Mật khẩu phải có ít nhất 6 ký tự")
                            .foregroundColor(AppColors.error)
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                
                // Login button
                Button(action: {
                    withAnimation {
                        viewModel.login(email: email, password: password)
                    }
                }) {
                    AppStyles.mainActionButton(title: "Đăng Nhập", icon: "arrow.right.circle.fill")
                }
                .padding(.horizontal)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(AppColors.error)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                // Register button
                Button(action: {
                    withAnimation {
                        showRegister = true
                    }
                }) {
                    Text("Chưa có tài khoản? Đăng ký ngay")
                        .foregroundColor(AppColors.primary)
                }
                .padding(.top)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView(viewModel: viewModel)
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 