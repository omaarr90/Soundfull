//
//  SoundfullNotificationManager.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/16/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class SoundfullNotificationManager: NSObject {
    static let sharedManager = SoundfullNotificationManager()
    
    func scheduleNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate()
        localNotification.alertBody = NSLocalizedString("Your file has finished downloading", comment: "")
        localNotification.applicationIconBadgeNumber += 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func sessionFinishedDownloading() {
        
        self.scheduleNotification()
    }
}
