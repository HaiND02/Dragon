import SwiftUI

struct FeaturedSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HeaderView(title: "Nổi Bật")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        FeaturedItemCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FeaturedItemCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .frame(width: 280, height: 180)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary)
                )
                .shadow(color: AppColors.cardShadow, radius: 10)
            
            Text("Tiêu đề")
                .font(.headline)
                .foregroundColor(AppColors.text)
            
            Text("Mô tả ngắn")
                .font(.subheadline)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.bottom)
    }
} 