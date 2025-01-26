import SwiftUI
import CoreData

@main
struct DragonApp: App {
    // Khởi tạo persistenceController như một @StateObject để đảm bảo lifecycle
    @StateObject private var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
} 