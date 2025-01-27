import SwiftUI

struct HeaderView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(AppColors.text)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 3)
                .frame(maxWidth: 100)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
} 