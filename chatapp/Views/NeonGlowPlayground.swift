import SwiftUI

struct NeonGlowPlayground: View {
    @State private var strokeWidth: CGFloat = 8.0
    @State private var glowColor: Color = .purple
    @State private var highlightOffset: CGPoint = .zero
    @State private var isDraggingHighlight = false
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Neon Glow View with touch interaction
                NeonGlowView2(
                    strokeWidth: strokeWidth,
                    glowColor: glowColor,
                    highlightOffset: highlightOffset
                )
                .frame(width: 300, height: 300)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingHighlight = true
                            // Normalize the offset relative to the view size
                            let normalizedX = value.location.x / 300 - 0.5
                            let normalizedY = value.location.y / 300 - 0.5
                            highlightOffset = CGPoint(x: normalizedX, y: normalizedY)
                        }
                        .onEnded { _ in
                            isDraggingHighlight = false
                        }
                )
                
                // Controls
                VStack(spacing: 15) {
                    // Stroke Width Slider
                    HStack {
                        Text("Stroke Width")
                            .foregroundColor(.white)
                        Slider(value: $strokeWidth, in: 2...20)
                        Text("\(strokeWidth, specifier: "%.1f")")
                            .foregroundColor(.white)
                    }
                    
                    // Color Picker
                    ColorPicker("Glow Color", selection: $glowColor)
                    
                    // Highlight Position Info
                    Text("Highlight Position")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("X: \(highlightOffset.x, specifier: "%.2f"), Y: \(highlightOffset.y, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text("Drag on the view to move highlight")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)
            }
            .padding()
        }
    }
}

#Preview {
    NeonGlowPlayground()
}
