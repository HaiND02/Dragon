import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Trang chủ")
            }
            
            NavigationView {
                ProfileView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Cá nhân")
            }
        }
    }
} 