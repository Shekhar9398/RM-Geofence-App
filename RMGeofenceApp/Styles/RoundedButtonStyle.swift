import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 150, height: 80)
            .background(backgroundColor)
            .foregroundColor(.white)
            .bold()
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    Button(action: {}) {
        Text("Demo")
            .foregroundColor(.white)
            .font(.headline.bold())
    }
    .buttonStyle(RoundedButtonStyle(backgroundColor: .red))
}
