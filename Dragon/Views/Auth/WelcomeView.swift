import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    let userName: String
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background gradient
            AppStyles.backgroundGradient()
                .ignoresSafeArea()
            
            // Animated circles background
            GeometryReader { geometry in
                Circle()
                    .fill(AppColors.gradientStart.opacity(0.1))
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: isAnimating ? geometry.size.width * 0.4 : -geometry.size.width * 0.2,
                           y: isAnimating ? geometry.size.height * 0.1 : geometry.size.height * 0.3)
                    .blur(radius: 30)
                
                Circle()
                    .fill(AppColors.gradientEnd.opacity(0.1))
                    .frame(width: geometry.size.width * 0.8)
                    .offset(x: isAnimating ? -geometry.size.width * 0.2 : geometry.size.width * 0.4,
                           y: isAnimating ? geometry.size.height * 0.6 : geometry.size.height * 0.4)
                    .blur(radius: 30)
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // Success animation
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [AppColors.gradientStart, AppColors.gradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 120, height: 120)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 10)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.0)
                .rotation3DEffect(
                    .degrees(isAnimating ? 360 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                
                // Welcome text
                VStack(spacing: 15) {
                    Text("Chào mừng")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text("Xin chào, \(userName)!")
                        .font(.title2)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Đăng ký thành công")
                        .font(.headline)
                        .foregroundColor(AppColors.success)
                }
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                
                Spacer()
                
                // Start button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showWelcome = false
                    }
                }) {
                    AppStyles.mainActionButton(title: "Bắt đầu Sử Dụng", icon: "arrow.forward.circle.fill")
                }
                .padding(.horizontal)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .shadow(color: AppColors.primary.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8)) {
                isAnimating = true
            }
            
            // Animate background circles
            withAnimation(
                .easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    WelcomeView(showWelcome: .constant(true), userName: "John Doe")
} 