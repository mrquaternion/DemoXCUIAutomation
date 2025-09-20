//
//  Types.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-19.
//

import Foundation

enum GameType: String, CaseIterable, Identifiable {
    case botw, minecraft, esv, lol, smg, fallout, halo, doom, pokemon
    var id: String { rawValue }
    
    var songFile: String {
        switch self {
        case .botw: return "botw_sf"
        case .minecraft: return "minecraft_sf"
        case .esv: return "esv_sf"
        case .lol: return "lol_sf"
        case .smg: return "smg_sf"
        case .fallout: return "fallout_sf"
        case .halo: return "halo_sf"
        case .doom: return "doom_sf"
        case .pokemon: return "pokemon_sf"
        }
    }
}

struct Game: Identifiable, Hashable {
    let id: GameType
    let gameName: String
    var isPlaying: Bool = false
    var amountPlayedInSeconds: Double = 0
    var imageName: String { id.rawValue }
}
