//
//  SoundConverter.swift
//  Moving Pics
//
//  Created by Omar Alshammari on 1/19/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import AVFoundation

private let SoundConvertTempMusiceDirectory = "SoundConverter/TempMusics"
private let soundConverterErroDomain = "com.omaarr90.soundconverter.errordomain"

protocol SoundConverterDelegate {
    func soundConverter(converter: SoundConverter, didFinishConvertingToURL url: NSURL?, withError error: NSError?)
    func soundConverterDidStartConverting(converter: SoundConverter)
    
}

enum SoundConverterErrorCodes: Int {
    case Default = 1001
    case Cancel
}


class SoundConverter: NSObject {
    
    override init() {
        if !NSFileManager.setupConverterTempMusicDirectory() {
            fatalError("could not set up temp directory for audio converter")
        } else {
            super.init()
        }
    }
    
    
    var delegate: SoundConverterDelegate?
    
    private var defaultError: NSError {
        get {
            let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("An Error has occured converting the file", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Cannot Convert",comment: "")]
            let error = NSError(domain: soundConverterErroDomain, code: SoundConverterErrorCodes.Default.rawValue, userInfo: userInfor)
            return error
        }
    }
    
    private var cancelError: NSError {
        get {
            let userInfor: [NSObject: AnyObject] = [NSLocalizedDescriptionKey: NSLocalizedString("Converting has been canceled", comment: ""), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Operation Canceled",comment: "")]
            let error = NSError(domain: soundConverterErroDomain, code: SoundConverterErrorCodes.Cancel.rawValue, userInfo: userInfor)
            return error
        }
    }
    
    
    // MARK: - public functions
    func convertToAudioAtURL(url: NSURL) {
        
        let asset = AVURLAsset(URL: url)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            self.delegate?.soundConverter(self, didFinishConvertingToURL: nil, withError: defaultError)
            return
        }
        
        let tempMusicDir = NSFileManager.defaultManager().soundConverterTempMusicPath
        let musicPath = tempMusicDir.stringByAppendingString("tempMusic.m4a")
        if NSFileManager.defaultManager().fileExistsAtPath(musicPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(musicPath)
            } catch {
                self.delegate?.soundConverter(self, didFinishConvertingToURL: nil, withError: defaultError)
            }
        }
        let tempURL = NSURL(fileURLWithPath: musicPath, isDirectory: false)
        exportSession.outputURL = tempURL
        exportSession.outputFileType = AVFileTypeAppleM4A
        
        self.delegate?.soundConverterDidStartConverting(self)
        exportSession.exportAsynchronouslyWithCompletionHandler {
            switch exportSession.status {
            case .Completed:
                self.delegate?.soundConverter(self, didFinishConvertingToURL: tempURL, withError: nil)
                break
            case .Cancelled:
                self.delegate?.soundConverter(self, didFinishConvertingToURL: nil, withError: self.cancelError)
                break
            case .Failed:
                self.delegate?.soundConverter(self, didFinishConvertingToURL: url, withError: nil)
                break
            default:
                self.delegate?.soundConverter(self, didFinishConvertingToURL: nil, withError: self.defaultError)
                break
            }
        }
    }
}

extension NSFileManager {
    var soundConverterTempMusicPath : String {
        get{
            let documentDirectory = NSTemporaryDirectory()
            let tempMusicPath = documentDirectory.stringByAppendingString(SoundConvertTempMusiceDirectory)
            return "\(tempMusicPath)/"
        }
    }
    
    class func setupConverterTempMusicDirectory() -> Bool{
        let defaultManager = self.defaultManager()
        
        if !defaultManager.fileExistsAtPath(defaultManager.soundConverterTempMusicPath){
            do {
                try self.defaultManager().createDirectoryAtPath(defaultManager.soundConverterTempMusicPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
            }
        }
        return true
    }
}
