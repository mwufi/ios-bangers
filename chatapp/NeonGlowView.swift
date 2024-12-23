import SwiftUI

struct NeonGlowView: View {
    let amount: Double
    let color: Color
    let glowRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Base circle with glow
            Circle()
                .trim(from: 0, to: amount)
                .stroke(color, lineWidth: 8)
                .shadow(color: color.opacity(0.8), radius: glowRadius)
                .shadow(color: color.opacity(0.6), radius: glowRadius)
            
            // Value text in center
            Text("$\(amount * 1000, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: color.opacity(0.8), radius: 10)
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        NeonGlowView(
            amount: 0.75,
            color: .purple
        )
    }
}
