//
//  SoundfullTextField.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/5/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SoundfullTextField: UITextField{
    internal var soundfullPlaceholder: String? {
        didSet {
            self.setTextFieldText()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configTextfield()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configTextfield()
    }
    
    private func configTextfield() {
        self.backgroundColor = UIColor.soundfullLightPurbleColor()
        self.borderStyle = .None
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor.whiteColor()
        self.textAlignment = .Center
    }
    
    private func setTextFieldText() {
        self.attributedPlaceholder = NSAttributedString(string: self.soundfullPlaceholder!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])

    }
    
}
