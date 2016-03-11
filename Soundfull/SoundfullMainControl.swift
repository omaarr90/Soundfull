//
//  SoundfullMainControl.swift
//  Soundfull
//
//  Created by Omar Alshammari on 2/26/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SoundfullMainControl: UIView {
    @IBOutlet weak var mySoundButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func newSoundFullMainControl() -> SoundfullMainControl {
        let smc = NSBundle.mainBundle().loadNibNamed("SoundfullMainControl", owner: nil, options: nil).first as! SoundfullMainControl
        smc.backgroundColor = UIColor.clearColor()
        return smc
    }
}
