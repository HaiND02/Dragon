import SwiftUI

struct FavoritesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                if true { // Replace with actual check for favorites
                    LazyVStack(spacing: 15) {
                        ForEach(0..<5) { _ in
                            FavoriteItemCard()
                        }
                    }
                    .padding()
                } else {
                    EmptyStateView(
                        icon: "heart.slash",
                        title: "Chưa có mục yêu thích",
                        message: "Các mục bạn yêu thích sẽ xuất hiện ở đây"
                    )
                }
            }
            .background(
                AppStyles.backgroundGradient(colorScheme: colorScheme)
                    .ignoresSafeArea()
            )
            .navigationTitle("Yêu Thích")
        }
    }
}

struct FavoriteItemCard: View {
    var body: some View {
        HStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.cardBackground)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(AppColors.primary)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tên sản phẩm")
                    .font(.headline)
                
                Text("Mô tả ngắn về sản phẩm")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                
                Text("100.000đ")
                    .font(.callout)
                    .foregroundColor(AppColors.primary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .shadow(color: AppColors.cardShadow, radius: 5)
    }
} 