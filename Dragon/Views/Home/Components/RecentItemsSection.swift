import SwiftUI

struct RecentItemsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HeaderView(title: "Gần Đây")
            
            LazyVStack(spacing: 15) {
                ForEach(0..<5) { _ in
                    RecentItemCard()
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecentItemCard: View {
    var body: some View {
        HStack(spacing: 15) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.primary)
                )
                .shadow(color: AppColors.cardShadow, radius: 5)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text("Tiêu đề mục gần đây")
                    .font(.headline)
                    .foregroundColor(AppColors.text)
                    .lineLimit(2)
                
                Text("Mô tả ngắn về mục này, có thể là một đoạn text dài...")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("2 giờ trước")
                        .font(.caption)
                }
                .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            // More button
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 30, height: 30)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .shadow(color: AppColors.cardShadow, radius: 5)
    }
}

#Preview {
    RecentItemsSection()
        .padding()
} 