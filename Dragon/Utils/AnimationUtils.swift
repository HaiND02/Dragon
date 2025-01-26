import SwiftUI

struct AnimationUtils {
    static let defaultSpring = Animation.spring(response: 0.8, dampingFraction: 0.8)
    
    static func slideIn(from edge: Edge, delay: Double = 0) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        ).animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay))
    }
    
    static let scaleInOut = AnyTransition.asymmetric(
        insertion: .scale.combined(with: .opacity),
        removal: .scale.combined(with: .opacity)
    )
} 