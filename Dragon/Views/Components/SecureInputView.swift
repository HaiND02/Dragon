import SwiftUI

struct SecureInputView: View {
    @Binding var text: String
    let placeholder: String
    @State private var isSecured: Bool = true
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "lock")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            Group {
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .foregroundColor(AppColors.primary)
                    .frame(width: 30)
                    .animation(.easeInOut(duration: 0.2), value: isSecured)
            }
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