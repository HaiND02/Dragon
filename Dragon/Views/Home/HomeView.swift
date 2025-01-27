import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stories
                StoriesView(viewModel: viewModel)
                
                // Posts
                ForEach(0..<10) { _ in
                    PostView()
                }
            }
        }
        .navigationTitle("Dragon")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            AppStyles.backgroundGradient(colorScheme: colorScheme)
                .ignoresSafeArea()
        )
    }
}

struct StoriesView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                // Current User Story
                if let currentUser = viewModel.currentUser {
                    VStack {
                        ProfileImage(viewModel: viewModel, user: currentUser, size: 65)
                        Text("Tin của bạn")
                            .font(.caption)
                    }
                }
                
                // Other Stories
                ForEach(0..<5) { _ in
                    VStack {
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 65, height: 65)
                            .overlay(
                                Image(systemName: "person")
                                    .foregroundColor(AppColors.primary)
                            )
                        Text("User")
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PostView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Post Header
            HStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person")
                            .foregroundColor(AppColors.primary)
                    )
                
                Text("Username")
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Post Content
            Rectangle()
                .fill(AppColors.cardBackground)
                .frame(height: 300)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(AppColors.primary)
                )
            
            // Post Actions
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
                
                Button(action: {}) {
                    Image(systemName: "bubble.right")
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .foregroundColor(AppColors.text)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
} 

