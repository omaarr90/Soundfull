//
//  MusicDetailsViewController.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/11/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import CircleSlider

class MusicDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var musicprogressContainerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var music: AudioFile!
    var cirlceControlView: CircleSlider!
    var myPlayer: MusicPlayerBrain!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = music.title!
        self.subtitleLabel.text = music.category!
        self.titleLabel.textColor = UIColor.whiteColor()
        self.subtitleLabel.textColor = UIColor.soundfullGrayColor()
        
        self.configureSlider()
        
        self.myPlayer = MusicPlayerBrain.sharedPlayerBrain
        self.myPlayer.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.myPlayer.playAudio(music)
        
        self.updateUI()
        self.startTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSlider() {
        let options: [CircleSliderOption] = [
            .BarColor(UIColor.soundfullGrayColor()),
            .ThumbColor(UIColor.soundfullOrangeColor()),
            .TrackingColor(UIColor.soundfullOrangeColor()),
            .BarWidth(10),
            .StartAngle(-90),
            .MaxValue(100),
            .MinValue(0)
        ]
        self.cirlceControlView = CircleSlider(frame: self.musicprogressContainerView.bounds, options: options)
        self.cirlceControlView.userInteractionEnabled = false
        self.musicprogressContainerView.addSubview(self.cirlceControlView)
    }
    
    @IBAction func pausePlayButtonClicked(sender: AnyObject) {
        if self.myPlayer.playing {
            self.pauseMusic()
        } else {
            self.resumeMusic()
        }
        
        self.changePlayPauseIcon()
    }
    
    
    private func updateUI() {
        self.changePlayPauseIcon()
    }
    
    private func updateSlider() {
        let musicTotalTime = self.myPlayer.duration
        let musicCurrentTime = self.myPlayer.currentTime
        
        let offset = musicCurrentTime / musicTotalTime
        
        
        self.cirlceControlView.value = Float(offset * 100)
    }
    
    private func changePlayPauseIcon() {
        if self.myPlayer.playing {
            self.playPauseButton.setImage(UIImage(named: "SoundApp_ pause_icon"), forState: .Normal)
        } else {
            self.playPauseButton.setImage(UIImage(named: "SoundApp_Play_icon"), forState: .Normal)
        }
        
    }

    private func pauseMusic() {
        self.myPlayer.pause()
    }
    
    private func resumeMusic() {
        self.myPlayer.play()
        self.startTimer()
    }
    
    private func stopMusic() {
        self.myPlayer.stop()
    }

    func startTimer() {
        
        let dpLink = CADisplayLink(target: self, selector: Selector("timerUpdated:"))
        dpLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func timerUpdated(timer: NSTimer) {
        self.updateSlider()
    }

}


extension MusicDetailsViewController: MusicPlayerBrainDelegate {
    func musicPlayerBrainDidFinishPlaying(musicPlayerBrain: MusicPlayerBrain, successfully: Bool) {
        self.changePlayPauseIcon()
    }
}
