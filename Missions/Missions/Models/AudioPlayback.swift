//
//  AudioPlayback.swift
//  Missions
//
//  Created by Umar Qattan on 12/23/19.
//  Copyright © 2019 Umar Qattan. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13, *)
final class AudioPlayback: NSObject, AVAudioPlayerDelegate {
    
    private override init() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error playing sound in AudioPlayback: \(error.localizedDescription)")
        }
    }
    
    static let shared = AudioPlayback()
    
    private(set) var audioPlayer = AVAudioPlayer()
    private(set) var playbackState: PlaybackState = .pause
    let url = Bundle.main.url(forResource: "sawtooth", withExtension: "mp3")!
    
    func play(pan: Float, volume: Float) {
        if playbackState == .pause {
            audioPlayer.pan = pan
            audioPlayer.volume = volume
            playbackState = playbackState.toggle
            audioPlayer.play()
        } else if playbackState == .play {
            audioPlayer.pause()
            playbackState = playbackState.toggle
        }
    }
    

    
    func setPanValue(_ pan: Float) {
        audioPlayer.pan = pan
    }
    
    func setVolumeValue(_ volume: Float) {
        audioPlayer.volume = volume
    }
    
    func skipToStart() {
        audioPlayer.currentTime = 0
        if playbackState == .play {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    func skipToEnd() {
        audioPlayer.currentTime = audioPlayer.duration
        audioPlayer.stop()
    }
}


