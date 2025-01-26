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
        ZStack {
            if authViewModel.isAuthenticated {
                if showWelcome {
                    WelcomeView(
                        showWelcome: $showWelcome,
                        userName: authViewModel.currentUser?.fullName ?? ""
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                } else {
                    // Main App View
                    HomeView(viewModel: authViewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            } else {
                LoginView(viewModel: authViewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    ))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: authViewModel.isAuthenticated)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showWelcome)
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