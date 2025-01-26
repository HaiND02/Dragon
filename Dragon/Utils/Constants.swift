import SwiftUI

struct AppColors {
    static let primary = Color(hex: "007AFF")
    static let secondary = Color(hex: "FF9500")
    static let cardBackground = Color.white
    static let text = Color(hex: "1C1C1E")
    static let error = Color(hex: "FF3B30")
    static let success = Color(hex: "34C759")
    static let textSecondary = Color.gray.opacity(0.8)
    
    // Background colors
    static let backgroundStart = Color(hex: "F6F8FD")
    static let backgroundEnd = Color(hex: "FFFFFF")
    static let gradientStart = Color(hex: "007AFF")
    static let gradientEnd = Color(hex: "5856D6")
}

struct AppStyles {
    static func primaryButton(title: String) -> some View {
        button(title: title)
            .background(
                LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    static func button(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .cornerRadius(15)
            .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
    
    static func backgroundGradient() -> some View {
        LinearGradient(
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func textField(text: Binding<String>, placeholder: String, icon: String) -> some View {
        inputField(icon: icon) {
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
        }
    }
    
    static func secureField(text: Binding<String>, placeholder: String) -> some View {
        inputField(icon: "lock") {
            SecureField(placeholder, text: text)
        }
    }
    
    static func inputField<T: View>(icon: String, @ViewBuilder content: () -> T) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppColors.primary.opacity(0.1), lineWidth: 1)
        )
    }
    
    static func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 10)
            )
    }
    
    static func mainActionButton(title: String, icon: String? = nil) -> some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    static func secondaryActionButton(title: String, icon: String? = nil) -> some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
        }
        .foregroundColor(AppColors.primary)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

// Helper extension để sử dụng mã màu hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 