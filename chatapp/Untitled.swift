//
//  Untitled.swift
//  chatapp
//
//  Created by Zen on 12/22/24.
//

import SwiftUI
import AVKit

struct Untitled: View {
    @State var show = false
    var videoUrl: String = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4"
    @State var player = AVPlayer()

    var body: some View {
        ZStack {
            if !show {
                TimelineView(.animation) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    VStack {
                        Image(systemName: "touchid")
                            .font(.system(size: 200).weight(.heavy))
                            .foregroundStyle(
                                ShaderLibrary.angledFill(
                                    .float(10),  // width
                                    .float(0),   // angle
                                    .color(.blue),
                                    .float(time)
                                )
                            )

                        Text(Date().formatted(date: .omitted, time: .standard))
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top)
                        
                        Text("View Transition")
                            .padding()
                            .background(Capsule().stroke())
                    }
                }
            } else {
                ZStack {
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.blue)
                            .padding()
                            .transition(.move(edge: .trailing))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.clear)
                                .frame(width: 300, height: 200)
                            VStack {
                                
                            Text(Date().formatted(date: .omitted, time: .standard))
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .padding(.top)
                                
                            VideoPlayer(player: player)
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .onAppear() {
                                    player = AVPlayer(url: URL(string: videoUrl)!)
                                }
                                .zIndex(1)
                            }
                        }
                    }
                    
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                show.toggle()
            }
        }
    }
}

#Preview {
 Untitled()
}
