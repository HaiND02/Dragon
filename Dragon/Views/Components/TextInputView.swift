import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding()
        .frame(height: 56) // Cố định chiều cao
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.cardShadow, radius: 15, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppColors.primary.opacity(0.1), lineWidth: 1)
        )
    }
} 