//
//  GameCard.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI
import AVKit

struct SoundtrackCard: View {
    let game: Game
    @Binding var isOn: Bool
    @ObservedObject var videoManager: VideoManager
    
    var timePlayed: String {
        let secondsPerMinute: Double = 60
        let minutesPerHour: Double = 60
        let hoursPerDay: Double = 24

        let secondsPerHour = secondsPerMinute * minutesPerHour
        let secondsPerDay = secondsPerHour * hoursPerDay
        
        if game.amountPlayedInSeconds == 0.0 {
            return "Not played yet"
        }

        if game.amountPlayedInSeconds >= secondsPerDay {
            // days
            return "Time played: \(Int(game.amountPlayedInSeconds / secondsPerDay)) days"
        } else if game.amountPlayedInSeconds >= secondsPerHour {
            // hours
            return "Time played: \(Int(game.amountPlayedInSeconds / secondsPerHour)) hours"
        } else if game.amountPlayedInSeconds >= secondsPerMinute {
            // minutes
            return "Time played: \(Int(game.amountPlayedInSeconds / secondsPerMinute)) minutes"
        } else {
            // seconds
            return "Time played: \(Int(game.amountPlayedInSeconds)) seconds"
        }
    }
    
    @State private var progress: Double = 0.6
    
    let basePhase: CGFloat = 1
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            HStack(spacing: 20) {
                if game.id == .esv && isOn {
                    VideoPlayer(player: videoManager.player)
                        .frame(width: 120, height: 120)
                
                } else {
                    Image(game.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipped()
                }
                
                VStack(alignment: .leading) {
                    Text(game.gameName)
                        .font(.headline)
                    Text(timePlayed)
                        .font(.callout)
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation { isOn.toggle() }   
                        } label: {
                            Image(systemName: isOn ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isOn ? .indigo : .red, .white)
                                .shadow(color: .black.opacity(0.7), radius: 1)
                        }
                        .accessibilityLabel("pb_\(game.id)")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 150)
    }
}

#Preview {
    let game: Game = .init(id: .esv, gameName: "The Elder Scrolls V: Skyrim", isPlaying: true)
    SoundtrackCard(game: game, isOn: .constant(true), videoManager: VideoManager())
}
