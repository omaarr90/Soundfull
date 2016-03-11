//
//  NSCharacterSet+URLEscape.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 1/16/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import Foundation

extension NSCharacterSet {
    
    public class func URLFullAllowedCharacterSet() -> NSCharacterSet {
        let charSet = NSMutableCharacterSet()
        let fragmentCharSet = NSCharacterSet.URLFragmentAllowedCharacterSet()
        let hostCharSet = NSCharacterSet.URLHostAllowedCharacterSet()
        let passwordCharSet = NSCharacterSet.URLPasswordAllowedCharacterSet()
        let pathCharSet = NSCharacterSet.URLPathAllowedCharacterSet()
        let queryCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        let userCharSet = NSCharacterSet.URLUserAllowedCharacterSet()
        
        charSet.formUnionWithCharacterSet(fragmentCharSet)
        charSet.formUnionWithCharacterSet(hostCharSet)
        charSet.formUnionWithCharacterSet(passwordCharSet)
        charSet.formUnionWithCharacterSet(pathCharSet)
        charSet.formUnionWithCharacterSet(queryCharSet)
        charSet.formUnionWithCharacterSet(userCharSet)
        
        return charSet
    }
}