import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundColor(AppColors.primary.opacity(0.7))
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.text)
            
            Text(message)
                .font(.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    EmptyStateView(
        icon: "heart.slash",
        title: "Chưa có mục yêu thích",
        message: "Các mục bạn yêu thích sẽ xuất hiện ở đây"
    )
} 