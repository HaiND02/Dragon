import SwiftUI

struct CategoriesSection: View {
    @Binding var selectedCategory: String?
    
    let categories = [
        ("Phổ biến", "star.fill"),
        ("Mới nhất", "clock.fill"),
        ("Xu hướng", "flame.fill"),
        ("Đề xuất", "sparkles"),
        ("Yêu thích", "heart.fill"),
        ("Xem sau", "bookmark.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HeaderView(title: "Danh Mục")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.0) { category in
                        CategoryCard(
                            title: category.0,
                            icon: category.1,
                            isSelected: selectedCategory == category.0
                        )
                        .onTapGesture {
                            withAnimation {
                                if selectedCategory == category.0 {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category.0
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoryCard: View {
    let title: String
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: isSelected ? 
                            [AppColors.primary, AppColors.primary.opacity(0.8)] :
                            [AppColors.gradientStart, AppColors.gradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
                .shadow(color: isSelected ? 
                    AppColors.primary.opacity(0.5) :
                    AppColors.primary.opacity(0.3),
                    radius: 8, x: 0, y: 4)
            
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .shadow(color: AppColors.cardShadow, radius: 5)
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

#Preview {
    CategoriesSection(selectedCategory: .constant(nil))
        .padding()
} 