import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    let userName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("Chào mừng")
                .font(.largeTitle)
                .bold()
            
            Text("Xin chào, \(userName)!")
                .font(.title2)
            
            Text("Đăng ký thành công")
                .foregroundColor(.gray)
            
            Button(action: {
                withAnimation {
                    showWelcome = false
                }
            }) {
                Text("Bắt đầu sử dụng")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }
} 