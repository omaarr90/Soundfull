//
//  MVLoadingView.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 1/22/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import FillableLoaders

class SoundfullLoadingView: UIView {
    
    var progress: Double! {
        didSet {
            self.fillableLoader.progress = CGFloat(self.progress)
        }
    }
    
    var loaderColor: UIColor? {
        didSet {
            self.fillableLoader.loaderColor = self.loaderColor
        }
    }
    
    var loaderBackgroundColor: UIColor? {
        didSet {
            self.fillableLoader.loaderBackgroundColor = self.loaderBackgroundColor
        }
    }
    
    var status: String! = "" {
        didSet{
            self.statusLabel.text = self.status
        }
    }
    
    var statusLabel: UILabel!
    
    var fillableLoader: FillableLoader!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initLoader()
    }
    
    // MARK: - private methods
    private func initLoader() {
        self.backgroundColor = UIColor.clearColor()
        self.configureLoader()
        self.configureLabel()
    }
    
    private func configureLoader() {
        let path = self.loadViewPath().CGPath
        self.fillableLoader = PlainLoader.createProgressBasedLoaderWithPath(path: path, onView: self)
        self.fillableLoader.rectSize = self.frame.size.height
        self.fillableLoader.loaderStrokeColor = UIColor.whiteColor()
        self.fillableLoader.loaderStrokeWidth = 2.0
        self.fillableLoader.showLoader()

    }
    
    private func configureLabel() {
        let frame = CGRect(x: self.fillableLoader.frame.origin.x, y: self.fillableLoader.frame.origin.y, width: self.fillableLoader.frame.size.width, height: self.fillableLoader.frame.size.height)
        let label = UILabel(frame: frame)
        label.center = self.fillableLoader.center
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(26.0)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        self.fillableLoader.addSubview(label)
        self.statusLabel = label

    }
    
    private func loadViewPath() -> UIBezierPath {
        let path = UIBezierPath(ovalInRect: self.frame)
        return path
    }
    
    private func twitterPath() -> UIBezierPath {
        //Created with PaintCode
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(190, 281))
        bezierPath.addCurveToPoint(CGPointMake(142, 329), controlPoint1: CGPointMake(163.49, 281), controlPoint2: CGPointMake(142, 302.49))
        bezierPath.addCurveToPoint(CGPointMake(190, 377), controlPoint1: CGPointMake(142, 355.51), controlPoint2: CGPointMake(163.49, 377))
        bezierPath.addCurveToPoint(CGPointMake(238, 329), controlPoint1: CGPointMake(216.51, 377), controlPoint2: CGPointMake(238, 355.51))
        bezierPath.addCurveToPoint(CGPointMake(190, 281), controlPoint1: CGPointMake(238, 302.49), controlPoint2: CGPointMake(216.51, 281))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;
        return bezierPath
    }

}
