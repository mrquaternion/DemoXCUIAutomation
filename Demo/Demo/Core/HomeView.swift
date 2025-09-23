//
//  HomeView.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    
    private let audioManager = AudioManager.shared
    
    let spaceFromIsland: Double = 30
    let spaceFromHeader: Double = 20
    let sidePadding: Double = 22
    
    @State private var games: [Game] = [
        .init(id: .botw, gameName: "The Legend of Zelda: Breath of the Wild", amountPlayedInSeconds: 13000),
        .init(id: .minecraft, gameName: "Minecraft", amountPlayedInSeconds: 1980),
        .init(id: .doom, gameName: "Doom Eternal", amountPlayedInSeconds: 53),
        .init(id: .lol, gameName: "League of Legends", amountPlayedInSeconds: 430)
    ]
    
    @State private var availableGames: [Game] = [
        .init(id: .smg, gameName: "Super Mario Galaxy"),
        .init(id: .fallout, gameName: "Fallout 4"),
        .init(id: .halo, gameName: "Halo: Combat Evolved"),
        .init(id: .esv, gameName: "The Elder Scrolls V:\nSkyrim"),
        .init(id: .pokemon, gameName: "Pokemon")
    ]
    
    @StateObject private var videoManager = VideoManager()
    
    @State private var playingGameID: GameType? = nil
    @State private var showSoundtracks: Bool = false
    @State private var addedGames: [GameType: Bool] = [:]
    
    init() {
        _addedGames = State(initialValue: Dictionary(uniqueKeysWithValues: availableGames.map { ($0.id, false) }))
    }
    
    var body: some View {
        VStack(spacing: 8) {	
            HomeHeader(showSoundtracks: $showSoundtracks)
                .padding(.top, spaceFromIsland)
                .padding(.horizontal, sidePadding)
            
            ScrollView {
                VStack(spacing: 25) {
                    ForEach($games) { $game in
                        SoundtrackCard(
                            game: game,
                            isOn: Binding(
                                get: { playingGameID == game.id },
                                set: { newValue in
                                    if newValue {
                                        playingGameID = game.id
                                        audioManager.togglePlay(for: game.id)
                                        
                                        if game.id == .esv {
                                            videoManager.togglePlay(fileName: "skyrim")
                                        } else {
                                            videoManager.pauseAndReset()
                                        }
                                    } else if playingGameID == game.id {
                                        playingGameID = nil
                                        audioManager.stop()
                                        videoManager.pauseAndReset()
                                    }
                                }
                            ),
                            videoManager: videoManager
                        )
                    }
                }
                .padding(.vertical, spaceFromHeader)
                .padding(.horizontal, sidePadding)
            }
            
            Text("Log Out")
                .fontWeight(.bold)
                .foregroundStyle(.red)
                .padding(.top)
                .onTapGesture { dismiss() }
        }
        .navigationBarBackButtonHidden()
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard let id = playingGameID,
                  let i = games.firstIndex(where: { $0.id == id }) else { return }
            games[i].amountPlayedInSeconds += 1
        }
        .sheet(isPresented: $showSoundtracks) {
            SheetContent(
                showSoundtracks: $showSoundtracks,
                availableGames: $availableGames,
                games: $games,
                addedGames: $addedGames
            )
                .presentationDetents([.large])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    HomeView()
}
