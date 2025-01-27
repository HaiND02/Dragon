import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var authViewModel: AuthViewModel
    
    init(context: NSManagedObjectContext) {
        let viewModel = AuthViewModel(context: context)
        _authViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if authViewModel.isAuthenticated {
            // Main App View
            MainTabView(viewModel: authViewModel)
        } else {
            // Auth Flow
            AuthView(viewModel: authViewModel)
        }
    }
}

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 