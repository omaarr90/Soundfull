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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = music.title!
        self.subtitleLabel.text = music.category!
        self.titleLabel.textColor = UIColor.whiteColor()
        self.subtitleLabel.textColor = UIColor.soundfullGrayColor()
        
        self.configureSlider()
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
        self.musicprogressContainerView.addSubview(self.cirlceControlView)
    }

}
