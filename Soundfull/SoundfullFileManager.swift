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
    
    class func saveData(data: NSData, withfileName fileName: String) -> String? {
        let fullPath = NSFileManager.musicDirectory().stringByAppendingString("\(fileName)")
        
        data.writeToFile(fullPath, atomically: true)
        
        return fullPath

    }
    
    class func getMusicDataForFileName(fileName: String) -> NSData {
        let fullFilePath = NSFileManager.musicPath.stringByAppendingString(fileName)
        
        let data = NSData(contentsOfFile: fullFilePath)
        return data!
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