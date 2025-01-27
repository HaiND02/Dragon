import SwiftUI

struct NotificationButton: View {
    @State private var hasNotifications = false
    
    var body: some View {
        Button(action: {
            // Handle notification tap
        }) {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.primary)
                .overlay(
                    Group {
                        if hasNotifications {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                )
        }
    }
} 