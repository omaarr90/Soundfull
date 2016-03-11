//
//  String+Soundfull.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/8/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import Foundation

extension String {
    func isValidURLString() -> Bool {
        // for now, just make sure it's not empty
        
        return !self.isEmpty
    }
}