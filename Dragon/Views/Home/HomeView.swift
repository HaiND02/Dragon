import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                AppStyles.backgroundGradient(colorScheme: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Welcome message
                    VStack(spacing: 10) {
                        Text("Xin chào,")
                            .font(.title)
                            .foregroundColor(AppColors.text.opacity(0.8))
                        
                        Text(viewModel.currentUser?.fullName ?? "")
                            .font(.title)
                            .bold()
                            .foregroundColor(AppColors.primary)
                    }
                    .card()
                    .animatedContent(isAnimating: isAnimating)
                    
                    // User info card
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primary)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(viewModel.currentUser?.fullName ?? "")
                                    .font(.headline)
                                Text(viewModel.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .card()
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                    
                    Spacer()
                    
                    // Logout button
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.logout()
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Đăng Xuất")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.red, Color.red.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.top, 50)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 