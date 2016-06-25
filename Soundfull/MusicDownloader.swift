//
//  MusicDownloader.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 10/23/15.
//  Copyright © 2015 Omar Alshammari. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

private let backgroundSessionConfiguration = "backgroundSessionConfigurationIdentifier"
private let musicDownloaderTempMusiceDirectory = "MusicDownloader/TempMusics"

protocol MusicDownloaderDelegate {
    func musicDownloader(downloader: MusicDownloader, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    func musicDownloader(downloader: MusicDownloader, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    func musicDownloader(downloader: MusicDownloader, didCompleteWithError error: NSError?)
    func musicDownloader(downloader: MusicDownloader, didFinishDownloadingToURL location: NSURL)
    
}

class MusicDownloader: NSObject {
    
    var downloadSession: NSURLSession!
    var delegate: MusicDownloaderDelegate?
    
    
    
    
    // MARK: - Initalizers
    override init () {
        if !NSFileManager.setupDownloaderTempMusicDirectory() {
            fatalError("could not setup temp directory for music downloader")
        } else {
            super.init()
            self.initDownloader()
        }
    }
    
    func initDownloader() {
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(backgroundSessionConfiguration)
        self.downloadSession = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    // MARK: - public methods
    func downloadFile(location: String) {
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(backgroundSessionConfiguration)
        self.downloadSession = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let nonescapedString = location.stringByRemovingPercentEncoding!
        guard let escapedString = nonescapedString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFullAllowedCharacterSet()), let  url = NSURL(string: escapedString) else {
            let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("Invalid URL", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("URL provided is invalid",comment: "")]
            let error = NSError(domain: "User Error", code: 1000, userInfo: userInfor)
            self.delegate?.musicDownloader(self, didCompleteWithError: error)
            return
        }
        let request = NSURLRequest(URL: url)
        let downloadTask = self.downloadSession.downloadTaskWithRequest(request)
        downloadTask.resume()
    }
}

extension MusicDownloader: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // Move url to temp Folder
        let tempMusicDir = NSFileManager.defaultManager().musicDownloaderTempMusicPath
        let musicPath = tempMusicDir.stringByAppendingString("tempMusic.m4a")
        
        
        if NSFileManager.defaultManager().fileExistsAtPath(musicPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(musicPath)
            } catch let error as NSError{
                self.delegate?.musicDownloader(self, didCompleteWithError: error)
            }
        }
        
        do {
            try NSFileManager.defaultManager().moveItemAtPath(location.path!, toPath: musicPath)
            let url = NSURL(fileURLWithPath: musicPath, isDirectory: false)
            self.delegate?.musicDownloader(self, didFinishDownloadingToURL: url)
        } catch let error as NSError {
            self.delegate?.musicDownloader(self, didCompleteWithError: error)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        self.delegate?.musicDownloader(self, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.delegate?.musicDownloader(self, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            self.delegate?.musicDownloader(self, didCompleteWithError: error)
        }
        
        self.downloadSession = nil
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler()
                })
            }
        }
    }
}

extension NSFileManager {
    var musicDownloaderTempMusicPath : String {
        get{
            let tempDir = NSTemporaryDirectory()
            let tempMusicPath = tempDir.stringByAppendingString(musicDownloaderTempMusiceDirectory)
            return "\(tempMusicPath)/"
        }
    }
    
    class func setupDownloaderTempMusicDirectory() -> Bool{
        let defaultManager = self.defaultManager()
        
        if !defaultManager.fileExistsAtPath(defaultManager.musicDownloaderTempMusicPath){
            do {
                try self.defaultManager().createDirectoryAtPath(defaultManager.musicDownloaderTempMusicPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return true
    }
}
