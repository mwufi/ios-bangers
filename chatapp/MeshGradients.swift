//
//  MeshGradients.swift
//  chatapp
//
//  Created by Zen on 12/22/24.
//

import SwiftUI

struct MeshGradients: View {
    @State private var animate = false
    
    let colors: [Color] = [
        .blue.opacity(0.8),
        .purple.opacity(0.8),
        .pink.opacity(0.8),
        .orange.opacity(0.8)
    ]
    
    var body: some View {
        ZStack {
            // Background base color
            Color.black
            
            // Multiple gradient blobs
            ForEach(0..<4) { index in
                RadialGradient(
                    gradient: Gradient(colors: [
                        colors[index],
                        colors[index].opacity(0)
                    ]),
                    center: .center,
                    startRadius: 1,
                    endRadius: 300
                )
                .scaleEffect(animate ? 1.2 : 0.8)
                .offset(
                    x: animate ? CGFloat.random(in: -100...100) : CGFloat.random(in: -100...100),
                    y: animate ? CGFloat.random(in: -100...100) : CGFloat.random(in: -100...100)
                )
                .blur(radius: 30)
                .animation(
                    Animation.easeInOut(duration: 4)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                    value: animate
                )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    MeshGradients()
}
