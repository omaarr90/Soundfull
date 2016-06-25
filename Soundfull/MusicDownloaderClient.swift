//
//  MusicDownloaderClient.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 1/22/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import XCDYouTubeKit

@objc protocol MusicClientDelegate {
    func musicClient(downloader: MusicDownloaderClient, didChangeProgress progress: Double)
    func musicClient(downloader: MusicDownloaderClient, didCompleteWithError error: NSError?)
    func musicClient(downloader: MusicDownloaderClient, didFinishDownloadingToURL location: NSURL)
    
    optional func musicClient(downloader: MusicDownloaderClient, didChangeStatus status: MusicDownloaderClientStatus)
}

@objc enum MusicDownloaderClientStatus: Int {
    case Preparing
    case Downloading
    case Finalizing
    case None
}

class MusicDownloaderClient: NSObject {
    private enum URLType {
        case Youtube
        case Regular
    }
    
    var downloader: MusicDownloader!
    var soundConverter: SoundConverter!
    var delegate: MusicClientDelegate?
    var status: MusicDownloaderClientStatus!
    var progress: Double!
    
    private var invalidateDelegate = false
    
    // MARK: - Initalizers
    override init () {
        super.init()
        self.initClient()
    }
    
    // MARK: - private function
    private func initClient() {
        self.downloader = MusicDownloader()
        self.downloader.delegate = self
        self.soundConverter = SoundConverter()
        self.soundConverter.delegate = self
        
        self.status = .None
    }
    
    private func urlType(location: String) -> URLType {
        if location.containsString("youtube") || location.containsString("youtu.be") {
            return .Youtube
        }
        return .Regular
    }
    
    private func downloadMusicForYoutubeType(location: String) {
        let youtubeID = self.getYoutubeVideoID(location)
        let youtubeClient = XCDYouTubeClient.defaultClient()
        self.didChangeStatus(.Preparing)
        youtubeClient.getVideoWithIdentifier(youtubeID) { (video, error) -> Void in
            if let streamURL = (video?.streamURLs[36]){
                self.downloadMusicAtPath("\(streamURL)")
            } else if let streamURL = (video?.streamURLs[18]) {
                self.downloadMusicAtPath("\(streamURL)")
            } else if let streamURL = (video?.streamURLs[22]) {
                self.downloadMusicAtPath("\(streamURL)")
            } else {
                let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("Could not download youtube file.", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Youtube is not supported",comment: "")]
                let error = NSError(domain: "User Error", code: 1000, userInfo: userInfor)
                self.invalidateDelegate = true
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate?.musicClient(self, didCompleteWithError: error)
                })
            }
        }
    }
    
    private func getYoutubeVideoID(location: String) -> String {
        let youtubeIDIndex = location.endIndex.advancedBy(-11)
        let youtubeID = location.substringFromIndex(youtubeIDIndex)
        return youtubeID
    }
    
    private func downloadMusicAtPath(location: String) {
        guard let url = NSURL(string: location) else {
            let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("The URL you entered is invalid", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("non audio file found",comment: "")]
            let error = NSError(domain: "User Error", code: 1000, userInfo: userInfor)
            self.invalidateDelegate = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient(self, didCompleteWithError: error)
            })
            
            return
        }
        self.isValidAudioFile(url) { (isValid) -> Void in
            if isValid {
                self.didChangeStatus(.Downloading)
                self.downloader.downloadFile(location)
            } else {
                let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("you are trying to download a non audio file", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("non audio file found",comment: "")]
                let error = NSError(domain: "User Error", code: 1000, userInfo: userInfor)
                self.invalidateDelegate = true
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate?.musicClient(self, didCompleteWithError: error)
                })
            }
        }
    }
    
    private func isValidAudioFile(url: NSURL, completionBlock: ( Bool -> Void)) {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "HEAD"
        
        let headTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            completionBlock(true)
        }
        self.didChangeStatus(.Preparing)
        headTask.resume()
    }
    
    private func didChangeStatus(status: MusicDownloaderClientStatus) {
        if self.status == status {
            return
        } else if !self.invalidateDelegate {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient?(self, didChangeStatus: status)
            })
        }
        self.status = status
    }
    
    // MARK: - public functions
    func getMusicAtPath(location: String) {
        self.didChangeStatus(.None)
        self.invalidateDelegate = false
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.delegate?.musicClient(self, didChangeProgress: 1.0)
        })
        let urlType = self.urlType(location)
        switch urlType {
        case .Youtube:
            self.downloadMusicForYoutubeType(location)
            break
        case .Regular:
            self.downloadMusicAtPath(location)
            break
        }
    }
}

extension MusicDownloaderClient: MusicDownloaderDelegate {
    func musicDownloader(downloader: MusicDownloader, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        self.didChangeStatus(.Downloading)
    }
    
    func musicDownloader(downloader: MusicDownloader, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        self.didChangeStatus(.Downloading)
        if !self.invalidateDelegate {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient(self, didChangeProgress: progress)
            })
        }
    }
    
    func musicDownloader(downloader: MusicDownloader, didFinishDownloadingToURL location: NSURL) {
        self.didChangeStatus(.Finalizing)
        self.soundConverter.convertToAudioAtURL(location)
    }
    
    func musicDownloader(downloader: MusicDownloader, didCompleteWithError error: NSError?) {
        if error != nil && !self.invalidateDelegate {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient(self, didCompleteWithError: error)
            })
        }
    }
}

extension MusicDownloaderClient: SoundConverterDelegate {
    func soundConverter(converter: SoundConverter, didFinishConvertingToURL url: NSURL?, withError error: NSError?) {
        self.invalidateDelegate = true
        if error != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient(self, didCompleteWithError: error)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.musicClient(self, didFinishDownloadingToURL: url!)
            })
            self.didChangeStatus(.None)
        }
    }
    
    func soundConverterDidStartConverting(converter: SoundConverter) {
        self.didChangeStatus(.Finalizing)
    }
}