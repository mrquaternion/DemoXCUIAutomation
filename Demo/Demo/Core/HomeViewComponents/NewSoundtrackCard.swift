//
//  NewSoundtrack.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-18.
//

import SwiftUI

struct NewSoundtrackCard: View {
    let game: Game
    @Binding var addedGames: [GameType: Bool]
    
    var body: some View {

            
        HStack(spacing: 20) {
            Image(game.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
            
            Spacer()

            Text(game.gameName)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                withAnimation { addedGames[game.id, default: false].toggle() }
            } label: {
                Image(systemName: addedGames[game.id, default: false] ? "checkmark" : "plus")
                    .font(.largeTitle)
                    .symbolVariant(.circle)
                    .foregroundStyle(addedGames[game.id, default: false] ? .green : .black)
            }
            .accessibilityLabel("add_\(game.id.rawValue)")
        }
        .padding()
    }
}

#Preview {
    let game: Game = .init(id: .esv, gameName: "The Elder Scrolls V: Skyrim", isPlaying: true)
    NewSoundtrackCard(game: game, addedGames: .constant([:]))
}
