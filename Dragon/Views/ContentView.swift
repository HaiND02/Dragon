import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var authViewModel: AuthViewModel
    @State private var showWelcome = false
    
    init(context: NSManagedObjectContext) {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(context: context))
    }
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if showWelcome {
                    WelcomeView(
                        showWelcome: $showWelcome,
                        userName: authViewModel.currentUser?.fullName ?? ""
                    )
                    .transition(.opacity)
                } else {
                    // Main App View
                    NavigationView {
                        VStack {
                            Text("Xin chào, \(authViewModel.currentUser?.fullName ?? "")")
                            
                            Button(action: {
                                authViewModel.logout()
                            }) {
                                Text("Đăng Xuất")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .navigationTitle("Trang Chủ")
                    }
                    .transition(.opacity)
                }
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
            if newValue && authViewModel.isNewUser {
                showWelcome = true
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return ContentView(context: context)
        .environment(\.managedObjectContext, context)
} 