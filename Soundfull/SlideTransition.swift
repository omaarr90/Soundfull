//
//  SlideTransition.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/17/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SlideTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        let containerView = transitionContext.containerView()
        
        fromView?.frame = self.initalFromViewFrameInContainer(containerView!)
        toView?.frame = self.initailToViewFrameInContainer(containerView!)
        
        containerView?.addSubview(toView!)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            fromView?.frame = self.finalFromViewFrameInContainer(containerView!)
            toView?.frame = self.finalToViewFrameInContainer(containerView!)
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    
    private func initailToViewFrameInContainer(container: UIView) -> CGRect {
        var rect = container.frame
        if self.operation == .Push {
            rect.origin.x = container.frame.origin.x + container.frame.size.width
        } else {
            rect.origin.x = container.frame.origin.x - container.frame.size.width
        }
        
        return rect
    }
    
    private func finalToViewFrameInContainer(container: UIView) -> CGRect {
        return container.frame
    }
    
    private func initalFromViewFrameInContainer(container: UIView) -> CGRect {
        return container.frame
    }
    
    private func finalFromViewFrameInContainer(container: UIView) -> CGRect {
        var rect = container.frame
        
        if self.operation == .Push {
            rect.origin.x = container.frame.origin.x - container.frame.size.width
        } else {
            rect.origin.x = container.frame.origin.x + container.frame.size.width
        }
        
        return rect

    }
}
