import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Welcome Image
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 70))
                .foregroundColor(AppColors.primary)
            
            // Welcome Text
            VStack(spacing: 10) {
                Text("Chào mừng")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(viewModel.currentUser?.fullName ?? "")
                    .font(.title2)
                    .foregroundColor(AppColors.primary)
                
                Text("Chúc bạn có những trải nghiệm tuyệt vời!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Start Button
            Button(action: {
                dismiss()
            }) {
                Text("Bắt đầu")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            AppStyles.backgroundGradient(colorScheme: colorScheme)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    WelcomeView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 