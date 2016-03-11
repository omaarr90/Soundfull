//
//  SoundfullFileManager.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/11/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
private let musiceDirectory = "/Musics"

class SoundfullFileManager: NSObject {
    
    class func persistURL(url: NSURL) -> String? {
        let fileName = url.lastPathComponent!
        let fullPath = NSFileManager.musicDirectory().stringByAppendingString("/\(fileName)")
        let destinationURL = NSURL(fileURLWithPath: fullPath)
        do {
            try NSFileManager.defaultManager().moveItemAtURL(url, toURL: destinationURL)
            return fullPath
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func deleteatPath(path: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

extension NSFileManager {
    static var musicPath : String {
        get{
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory , .UserDomainMask, true)
            let documentDirectory = paths[0]
            let musicPath = documentDirectory.stringByAppendingString(musiceDirectory)
            return "\(musicPath)/"
        }
    }
    
    class func musicDirectory() -> String {
        if !NSFileManager.defaultManager().fileExistsAtPath(NSFileManager.musicPath){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(NSFileManager.musicPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch _ {
                NSLog("%@", "An Error Has Occured creating a Directory")
            }
        }
        return NSFileManager.musicPath
    }
}