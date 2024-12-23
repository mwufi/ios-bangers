import SwiftUI

struct NeonGlowView2: View {
    let strokeWidth: CGFloat
    let glowColor: Color
    let highlightOffset: CGPoint
    let amount: Double = 0.7 // Fixed amount for now
    let glowRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Base glow circle
            Circle()
                .trim(from: 0, to: amount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            glowColor.opacity(0.8),
                            glowColor,
                            glowColor.opacity(0.8)
                        ]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0,
                        dash: [],
                        dashPhase: 0
                    )
                )
                .shadow(color: glowColor.opacity(0.8), radius: glowRadius)
                .shadow(color: glowColor.opacity(0.6), radius: glowRadius)
            
            // Soft white inner glow with adjustable position
            Circle()
                .trim(from: 0, to: amount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.05), location: 0),
                            .init(color: .white.opacity(0.5), location: 0.3),
                            .init(color: .white.opacity(0.2), location: 0.7),
                            .init(color: .white.opacity(0.05), location: 1)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: strokeWidth * 0.75,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .blur(radius: 2)
                .blendMode(.plusLighter)
                .offset(x: highlightOffset.x * 100, y: highlightOffset.y * 100)
            
            // Variable thickness overlay
            Circle()
                .trim(from: 0, to: amount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: glowColor.opacity(0.4), location: 0),
                            .init(color: glowColor.opacity(0.8), location: 0.5),
                            .init(color: glowColor.opacity(0.4), location: 1)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: strokeWidth * 1.5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .blur(radius: 3)
                .blendMode(.plusLighter)
            
            // Value text in center
            Text("$\(amount * 1000, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: glowColor.opacity(0.8), radius: 10)
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        NeonGlowView2(
            strokeWidth: 8,
            glowColor: .purple,
            highlightOffset: .zero
        )
    }
}
