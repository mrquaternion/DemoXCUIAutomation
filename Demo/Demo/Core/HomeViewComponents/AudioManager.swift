//
//  AudioManager.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import AVKit

final class AudioManager {
    private var player: AVAudioPlayer?
    private(set) var current: GameType?

    func togglePlay(for id: GameType) {
        if current == id {
            player?.stop()
            current = nil
            return
        }
        guard let path = Bundle.main.path(forResource: "\(id.songFile).mp3", ofType: nil) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.numberOfLoops = -1
            player?.play()
            current = id
        } catch {
            print("Audio error:", error)
        }
    }

    func stop() {
        player?.stop()
        current = nil
    }
}

