import SwiftUI

struct DragonLogoView: View {
    let size: CGFloat
    @State private var isAnimating = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Main circle with D
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "007AFF"),  // Blue
                            Color(hex: "5856D6")   // Purple
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color(hex: "007AFF").opacity(0.3), radius: 15, x: 0, y: 8)
                .overlay(
                    Text("D")
                        .font(.system(size: size * 0.6, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .offset(x: size * 0.02) // Để chữ D cân đối hơn
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                )
                .overlay(
                    // Small dragon icon
                    Image(systemName: "dragon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 0.25)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                        .rotationEffect(.degrees(isAnimating ? 3 : -3))
                        .offset(x: size * 0.25, y: -size * 0.25)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                )
                .scaleEffect(isAnimating ? 1 : 0.8)
                .opacity(isAnimating ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "F5F5F5")
            .ignoresSafeArea()
        DragonLogoView(size: 120)
    }
} 