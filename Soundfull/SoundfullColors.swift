//
//  SoundfullColors.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/5/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

extension UIColor {
    
    internal class func soundfullOrangeColor() -> UIColor{
        return UIColor.colorWithFullRGB(249.0, green: 142.0, blue: 43.0, alpha: 1.0)
    }
    
    internal class func soundfullPurbleColor() -> UIColor{
        return UIColor.colorWithFullRGB(102.0, green: 44.0, blue: 145.0, alpha: 1.0)
    }
    
    internal class func soundfullPurbleCColor() -> UIColor{
        return UIColor.colorWithFullRGB(100.0, green: 39.0, blue: 147.0, alpha: 1.0)
    }
    
    internal class func soundfullPurbleMColor() -> UIColor{
        return UIColor.colorWithFullRGB(78.0, green: 34.0, blue: 112.0, alpha: 1.0)
    }
    
    internal class func soundfullLightPurbleColor() -> UIColor{
        return UIColor.colorWithFullRGB(127.0, green: 79.0, blue: 153.0, alpha: 1.0)
    }
    
    internal class func soundfullGrayColor() -> UIColor{
        return UIColor.colorWithFullRGB(159.0, green: 157.0, blue: 155.0, alpha: 1.0)
    }
    
    internal class func soundfullRedColor() -> UIColor{
        return UIColor.colorWithFullRGB(203.0, green: 33.0, blue: 39.0, alpha: 1.0)
    }
    
    private class func colorWithFullRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}