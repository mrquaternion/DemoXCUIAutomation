//
//  VideoManager.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-11.
//

import AVKit
import Combine

final class VideoManager: ObservableObject {
    let player = AVPlayer()

    func togglePlay(fileName: String, fileExtension: String = "mp4") {
        if player.timeControlStatus == .playing {
            pauseAndReset()
        } else if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
            player.play()
        }
    }

    func pauseAndReset() {
        player.pause()
        player.seek(to: .zero)
    }
}
