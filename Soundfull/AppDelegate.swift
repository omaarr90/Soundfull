//
//  AppDelegate.swift
//  Soundfull
//
//  Created by Omar Alshammari on 2/26/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import MagicalRecord
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var musicPlayerBrain =  MusicPlayerBrain.sharedPlayerBrain
    var backgroundSessionCompletionHandler: (() -> Void)?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        MagicalRecord.setupCoreDataStack()
        
        // Allow background playing of Music
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }

    func applicationWillTerminate(application: UIApplication) {
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        MagicalRecord.cleanUp()
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch event!.subtype {
        case .RemoteControlTogglePlayPause:
            //            self.changePlayPauseIcon()
            break
        case .RemoteControlStop:
            self.musicPlayerBrain.stop()
            break
        case .RemoteControlPreviousTrack:
            break
        case .RemoteControlPlay:
            self.musicPlayerBrain.play()
            break
        case .RemoteControlPause:
            self.musicPlayerBrain.pause()
            break
        case .RemoteControlNextTrack:
            break
        case .RemoteControlEndSeekingForward:
            break
        case .RemoteControlEndSeekingBackward:
            break
        case .RemoteControlBeginSeekingForward:
            break
        case .RemoteControlBeginSeekingBackward:
            break
        case .None:
            break
        case .MotionShake:
            break
            
        }
    }

}

