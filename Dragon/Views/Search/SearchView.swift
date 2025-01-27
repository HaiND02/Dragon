import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.primary)
                    
                    TextField("Tìm kiếm...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Search results
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(0..<10) { _ in
                            SearchItemCard()
                        }
                    }
                    .padding()
                }
            }
            .background(
                AppStyles.backgroundGradient(colorScheme: colorScheme)
                    .ignoresSafeArea()
            )
            .navigationTitle("Tìm Kiếm")
        }
    }
}

struct SearchItemCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.cardBackground)
                .frame(height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(AppColors.primary)
                )
            
            Text("Tên sản phẩm")
                .font(.subheadline)
                .bold()
                .lineLimit(2)
            
            Text("100.000đ")
                .font(.caption)
                .foregroundColor(AppColors.primary)
        }
        .padding(8)
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .shadow(color: AppColors.cardShadow, radius: 5)
    }
} 