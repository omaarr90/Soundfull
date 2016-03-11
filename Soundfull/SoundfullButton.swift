//
//  SoundfullButton.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/5/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SoundfullButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configButton()
    }
    
    private func configButton() {
        self.backgroundColor = UIColor.soundfullOrangeColor()
        self.layer.cornerRadius = 5.0
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}
