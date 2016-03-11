//
//  UIViewController+Swift.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/8/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlertWithMessage(message: String) {
        let alertcontroller = UIAlertController(title: "Soundfull", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("O.K", comment: ""), style: .Cancel) { (action) -> Void in
            alertcontroller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertcontroller.addAction(okAction)
        
        self.presentViewController(alertcontroller, animated: true, completion: nil)
    }
}