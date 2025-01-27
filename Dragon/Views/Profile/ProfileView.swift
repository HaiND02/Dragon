import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showEditProfile = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header Profile
                VStack(spacing: 15) {
                    // Avatar
                    ProfileImage(viewModel: viewModel, user: viewModel.currentUser, size: 100)
                        .overlay(
                            Button(action: { showEditProfile = true }) {
                                Circle()
                                    .fill(AppColors.primary)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    )
                            }
                            .offset(x: 35, y: 35)
                        )
                    
                    // User Info
                    VStack(spacing: 8) {
                        Text(viewModel.currentUser?.fullName ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        if let location = viewModel.currentUser?.location, !location.isEmpty {
                            Label(location, systemImage: "location.fill")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Text(viewModel.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Menu Options
                VStack(spacing: 1) {
                    MenuButton(icon: "person.fill", title: "Thông tin cá nhân") {
                        showEditProfile = true
                    }
                    
                    MenuButton(icon: "bell.fill", title: "Thông báo") {
                        // Handle notifications
                    }
                    
                    MenuButton(icon: "gear", title: "Cài đặt") {
                        // Handle settings
                    }
                    
                    MenuButton(icon: "questionmark.circle.fill", title: "Trợ giúp") {
                        // Handle help
                    }
                    
                    MenuButton(icon: "arrow.right.circle.fill", title: "Đăng xuất", color: .red) {
                        showLogoutAlert = true
                    }
                }
                .background(AppColors.cardBackground)
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(
            AppStyles.backgroundGradient(colorScheme: colorScheme)
                .ignoresSafeArea()
        )
        .navigationTitle("Tài khoản")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .alert("Đăng xuất", isPresented: $showLogoutAlert) {
            Button("Hủy", role: .cancel) { }
            Button("Đăng xuất", role: .destructive) {
                viewModel.logout()
            }
        } message: {
            Text("Bạn có chắc chắn muốn đăng xuất?")
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    var color: Color = AppColors.text
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationView {
        ProfileView(viewModel: AuthViewModel(context: PersistenceController.preview.container.viewContext))
    }
}

