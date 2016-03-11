//
//  SoundfullNavigationDelegate.swift
//  Soundfull
//
//  Created by Omar Alshammari on 2/26/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SoundfullNavigationDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        //
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        viewController.view.backgroundColor = UIColor.clearColor()
        viewController.view.subviews.generate(children: { $0.subviews }).forEach {
            if !$0.isKindOfClass(UIControl) {
                $0.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation {
        return .Portrait
    }
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .AllButUpsideDown
    }
}

extension SequenceType {
    
    public func generate<S : SequenceType where S.Generator.Element == Generator.Element>
        (children children: Generator.Element -> S) -> AnyGenerator<Generator.Element> {
            
            var selfGenerator = self.generate()
            var childGenerator : AnyGenerator<Generator.Element>?
            
            return anyGenerator {
                // Enumerate all children of the current element:
                if childGenerator != nil {
                    if let next = childGenerator!.next() {
                        return next
                    }
                }
                
                // Get next element of self, and prepare subGenerator to enumerate its children:
                if let next = selfGenerator.next() {
                    childGenerator = children(next).generate(children: children)
                    return next
                }
                
                return nil
            }
    }
}