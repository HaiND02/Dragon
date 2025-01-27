import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.isNewUser {
                WelcomeView(viewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
} 