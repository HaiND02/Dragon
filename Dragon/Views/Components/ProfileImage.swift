import SwiftUI

struct ProfileImage: View {
    @ObservedObject var viewModel: AuthViewModel
    let user: User?
    var size: CGFloat = 100
    
    var body: some View {
        Group {
            if let user = user,
               let image = viewModel.loadProfileImage(for: user) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppColors.cardBackground, lineWidth: 2))
            } else {
                defaultImage
            }
        }
        .shadow(color: AppColors.cardShadow, radius: 5)
    }
    
    private var defaultImage: some View {
        Circle()
            .fill(AppColors.cardBackground)
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.2)
                    .foregroundColor(AppColors.primary)
            )
            .overlay(Circle().stroke(AppColors.cardBackground, lineWidth: 2))
    }
}

#Preview {
    ProfileImage(viewModel: AuthViewModel.shared, user: nil)
} 