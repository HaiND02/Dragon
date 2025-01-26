import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

struct AnimatedContentModifier: ViewModifier {
    let isAnimating: Bool
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            .animation(AnimationUtils.defaultSpring.delay(delay), value: isAnimating)
    }
}

extension View {
    func card() -> some View {
        modifier(CardModifier())
    }
    
    func animatedContent(isAnimating: Bool, delay: Double = 0) -> some View {
        modifier(AnimatedContentModifier(isAnimating: isAnimating, delay: delay))
    }
} 