import SwiftUI

struct NeonGlowView2: View {
    let amount: Double
    let color: Color
    let glowRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Base glow circle
            Circle()
                .trim(from: 0, to: amount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.8),
                            color,
                            color.opacity(0.8)
                        ]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0,
                        dash: [],
                        dashPhase: 0
                    )
                )
                .shadow(color: color.opacity(0.8), radius: glowRadius)
                .shadow(color: color.opacity(0.6), radius: glowRadius)
            
            // Soft white inner glow
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
                        lineWidth: 6, // Slightly thinner
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .blur(radius: 2) // Add slight blur to soften edges
                .blendMode(.plusLighter)
            
            // Variable thickness overlay
            Circle()
                .trim(from: 0, to: amount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: color.opacity(0.4), location: 0),
                            .init(color: color.opacity(0.8), location: 0.5),
                            .init(color: color.opacity(0.4), location: 1)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 12, // Wider base for variable thickness
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .blur(radius: 3) // Soft blur for smooth variation
                .blendMode(.plusLighter)
            
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
        
        NeonGlowView2(
            amount: 0.7,
            color: .purple
        )
    }
}
