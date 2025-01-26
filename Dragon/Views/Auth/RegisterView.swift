import SwiftUI
import CoreData

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var isAnimating = false
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            AppStyles.backgroundGradient(colorScheme: colorScheme)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    Text("Tạo Tài Khoản")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(AppColors.text)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        // Full name field
                        TextInputView(text: $fullName, placeholder: "Họ và tên", icon: "person")
                            .padding(.horizontal)
                            .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width)
                        
                        // Email field
                        TextInputView(text: $email, placeholder: "Email", icon: "envelope")
                            .padding(.horizontal)
                            .offset(x: isAnimating ? 0 : UIScreen.main.bounds.width)
                        
                        // Password fields
                        SecureInputView(text: $password, placeholder: "Mật khẩu")
                            .padding(.horizontal)
                            .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width)
                        
                        SecureInputView(text: $confirmPassword, placeholder: "Xác nhận mật khẩu")
                            .padding(.horizontal)
                            .offset(x: isAnimating ? 0 : UIScreen.main.bounds.width)
                    }
                    .padding(.horizontal)
                    
                    // Error messages
                    Group {
                        if !viewModel.isValidEmail(email) && !email.isEmpty {
                            Text("Email không hợp lệ")
                                .foregroundColor(AppColors.error)
                                .font(.caption)
                        }
                        
                        if !viewModel.isValidPassword(password) && !password.isEmpty {
                            Text("Mật khẩu phải có ít nhất 6 ký tự")
                                .foregroundColor(AppColors.error)
                                .font(.caption)
                        }
                        
                        if password != confirmPassword && !confirmPassword.isEmpty {
                            Text("Mật khẩu xác nhận không khớp")
                                .foregroundColor(AppColors.error)
                                .font(.caption)
                        }
                    }
                    
                    // Register button
                    Button(action: {
                        withAnimation {
                            if password == confirmPassword {
                                viewModel.register(email: email,
                                                 password: password,
                                                 fullName: fullName)
                                if viewModel.isAuthenticated {
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        AppStyles.mainActionButton(title: "Đăng Ký", icon: "person.badge.plus")
                    }
                    .padding(.horizontal)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .foregroundColor(AppColors.error)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                }
            }
            
            // Close button
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
}