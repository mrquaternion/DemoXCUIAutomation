//
//  SheetContent.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-19.
//

import SwiftUI

struct SheetContent: View {
    @Binding var showSoundtracks: Bool
    @Binding var availableGames: [Game]
    @Binding var games: [Game]
    @Binding var addedGames: [GameType: Bool]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack {
                    Text("add your soundtracks".capitalized)
                        .font(.headline)
                        .fontWeight(.semibold)

                    HStack {
                        Spacer()
                        Button("confirm".capitalized) {
                            let selectedIDs = addedGames.filter { $0.value }.map { $0.key }
                                
                            // 1. Append selected games to `games`
                            let selectedGames = availableGames.filter { selectedIDs.contains($0.id) }
                            games.append(contentsOf: selectedGames)
                            
                            // 2. Remove selected games from `availableGames`
                            availableGames.removeAll { selectedIDs.contains($0.id) }
                            
                            for id in selectedIDs {
                                addedGames[id] = false
                            }
                            
                            showSoundtracks = false
                        }
                        .font(.system(size: 14))
                        .padding(.trailing)
                        .accessibilityLabel("confirm_selection")
                    }
                }
                .frame(height: 44)
                
                Divider()
            }
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach($availableGames) { $game in
                        NewSoundtrackCard(game: game, addedGames: $addedGames)
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    var games: [Game] = [
        .init(id: .botw, gameName: "The Legend of Zelda: Breath of the Wild", amountPlayedInSeconds: 13000),
        .init(id: .minecraft, gameName: "Minecraft", amountPlayedInSeconds: 1980),
        .init(id: .esv, gameName: "The Elder Scrolls V:\nSkyrim"),
        .init(id: .lol, gameName: "League of Legends", amountPlayedInSeconds: 430)
    ]
    
    var availableGames: [Game] = [
        .init(id: .smg, gameName: "Super Mario Galaxy"),
        .init(id: .fallout, gameName: "Fallout 4"),
        .init(id: .halo, gameName: "Halo: Combat Evolved"),
        .init(id: .doom, gameName: "Doom Eternal"),
        .init(id: .pokemon, gameName: "Pokemon")
    ]
    
    SheetContent(
        showSoundtracks: .constant(true),
        availableGames: .constant(availableGames),
        games: .constant(games),
        addedGames: .constant([:])
    )
}
