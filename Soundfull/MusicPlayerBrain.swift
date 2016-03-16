//
//  MusicPlayerBrain.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 1/23/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol MusicPlayerBrainDelegate {
    func musicPlayerBrainDidFinishPlaying(musicPlayerBrain: MusicPlayerBrain, successfully: Bool)
}

class MusicPlayerBrain: NSObject {
    
    private var fileName: String!
    private var myPlayer: AVAudioPlayer!
    
    var delegate: MusicPlayerBrainDelegate?
    
    var playing: Bool {
        get {
            if self.myPlayer != nil{
                return self.myPlayer.playing
            } else {
                return false
            }
        }
    }
    
    var duration: NSTimeInterval {
        get {
            if self.myPlayer != nil{
                return self.myPlayer.duration
            } else {
                return 1.0
            }
        }
    }
    
    var currentTime: NSTimeInterval {
        get {
            if self.myPlayer != nil {
                return self.myPlayer.currentTime
            } else {
                return 0.0
            }
        }
    }
        
    class var sharedPlayerBrain: MusicPlayerBrain {
        struct Static {
            static let instance: MusicPlayerBrain = MusicPlayerBrain()
        }
        return Static.instance
    }
    
    private override init(){}
    
    private func setPlayingNowInfoForMusic(music: AudioFile) {
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            print("AVAudioSession is Active")
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        let image = UIImage(named: "musicPlayerLockScreen")
        let albumArt = MPMediaItemArtwork(image: image!)
        
        let songInfo: Dictionary = [
            MPMediaItemPropertyTitle: music.title!,
            MPMediaItemPropertyArtist: music.category!,
            MPMediaItemPropertyArtwork: albumArt,
            MPMediaItemPropertyPlaybackDuration: self.myPlayer.duration,
//            MPMediaItemPropertyAssetURL: NSFileManager.getMusicWithFileName(music.fileName)
        ]
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
        

    }
}


extension MusicPlayerBrain: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
        self.delegate?.musicPlayerBrainDidFinishPlaying(self, successfully: flag)
        self.myPlayer = nil
    }
    
}


/* public functions */
extension MusicPlayerBrain {
    func playAudio(music: AudioFile) {
        
        let fileName = music.discURL
        
        if (self.myPlayer != nil && self.fileName == fileName) {
            // Do nothing
            return
        } else if self.myPlayer != nil{
            self.myPlayer.delegate = nil
            self.myPlayer = nil
        }
        
        do {
            let data = SoundfullFileManager.getMusicDataForFileName("\(music.title!)\(music.category!).m4a")
            try myPlayer = AVAudioPlayer(data: data, fileTypeHint: AVFileTypeAppleM4A)
            myPlayer.delegate = self
            myPlayer.prepareToPlay()
            myPlayer.play()
            self.myPlayer.meteringEnabled = true
            self.setPlayingNowInfoForMusic(music)
        } catch let err as NSError {
            NSLog("ERR \(err.description)")
        }

        
        self.fileName = fileName
        
        
    }
    
    func pause() {
        self.myPlayer.pause()
    }
    
    func stop() {
        self.myPlayer.stop()
        self.myPlayer.currentTime = 0.0
    }
    
    func play() {
        self.myPlayer.play()
    }
    
    func updateMeters() {
        self.myPlayer.updateMeters()
    }
    
    func averagePowerForChannel(channel: Int) -> Float {
        return self.myPlayer.averagePowerForChannel(channel)
    }
}