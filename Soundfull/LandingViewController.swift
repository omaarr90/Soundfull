//
//  ViewController.swift
//  Soundfull
//
//  Created by Omar Alshammari on 2/26/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    private var hasAnimated = false
    private var soundfullMainControl: SoundfullMainControl!
    private var downloaderClient: MusicDownloaderClient!
    var loadingView: SoundfullLoadingView!
    private var musicTitle: String!
    private var musicCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = NSLocalizedString("Soundfull", comment: "First Page Title")
        
        self.downloaderClient = MusicDownloaderClient()
        self.downloaderClient.delegate = self
        
        self.initSoundfullLoadingView()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAnimated {
            self.animate()
        }
    }
    
    private func animate() {
        self.soundfullMainControl = self.soundFullMainCountrol()
        self.soundfullMainControl.alpha = 0.0
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.soundfullMainControl.alpha = 1.0
            }) { (finished) -> Void in
                self.hasAnimated = true
        }
    }
    
    private func initSoundfullLoadingView() {
        self.loadingView = SoundfullLoadingView(frame: CGRectMake(0, 0, 300, 300))
        self.loadingView.center = view.center
        self.loadingView.loaderBackgroundColor = UIColor.clearColor()
        self.loadingView.loaderColor = UIColor.soundfullOrangeColor()
        self.loadingView.alpha = 0.0
        self.view.addSubview(self.loadingView)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "downloadMusicSegue" {
            let destinationViewController = segue.destinationViewController as! DownloadMusicViewController
            destinationViewController.delegate = self
        }
    }
    
    private func soundFullMainCountrol() -> SoundfullMainControl {
        let smc = SoundfullMainControl.newSoundFullMainControl()
        smc.translatesAutoresizingMaskIntoConstraints = false
        
        smc.linkButton.addTarget(self, action: Selector("linkButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.galleryButton.addTarget(self, action: Selector("galleryButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.mySoundButton.addTarget(self, action: Selector("mysoundButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.mySoundButton.setTitle(NSLocalizedString("My Sounds", comment: ""), forState: .Normal)
        
        self.view.addSubview(smc)
        self.view.sendSubviewToBack(smc)
        
        let centerX = NSLayoutConstraint(item: smc, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: smc, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: smc, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 300)
        
        let heightConstraint = NSLayoutConstraint(item: smc, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 320)
        
        self.view.addConstraints([centerX, centerY, widthConstraint, heightConstraint])
        
        return smc
    }
    
    private func showMainControl() {
        self.soundfullMainControl.alpha = 0.0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.soundfullMainControl.alpha = 1.0
            self.loadingView.alpha = 0.0
            }) { (finished) -> Void in
        }
    }
    
    private func showLoadingView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.soundfullMainControl.alpha = 0.0
            self.loadingView.alpha = 1.0
            },completion: nil)
    }
    
    private func registerNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}

//MARK: - IBActions
extension LandingViewController {
    
    func linkButtonClicked(button: UIButton) {
        self.performSegueWithIdentifier("downloadMusicSegue", sender: self)
    }
    
    func galleryButtonClicked(button: UIButton) {
        self.showErrorAlertWithMessage(NSLocalizedString("Coming Soon, you will be able to convert any viedo from your library to audio.", comment: ""))
    }
    
    func mysoundButtonClicked(button: UIButton) {
        self.performSegueWithIdentifier("showMusics", sender: self)
    }
}

extension LandingViewController: DownloadMusicViewControllerDelegate {
    func didClickDownloadWithValidURL(urlSring: String, andTitle title: String, andCategory category: String, forViewController viewController: UIViewController) {
        viewController.navigationController?.popViewControllerAnimated(true)
        self.downloaderClient.getMusicAtPath(urlSring)
        self.musicTitle = title
        self.musicCategory = category
    }    
}

extension LandingViewController: MusicClientDelegate {
    func musicClient(downloader: MusicDownloaderClient, didChangeProgress progress: Double)
    {
        self.showLoadingView()
        self.loadingView.progress = progress
        if progress < 1.0 && progress > 0.0 {
            let downloadedLabel = NSLocalizedString("Downloaded", comment: "")
            self.loadingView.status = "\(Int(progress * 100)) % \r \(downloadedLabel)"
        }
    }
    
    func musicClient(downloader: MusicDownloaderClient, didChangeStatus status: MusicDownloaderClientStatus)
    {
        self.registerNotifications()
        self.showLoadingView()
        switch status {
        case .Preparing:
            self.loadingView.status = NSLocalizedString("Preparing...", comment: "")
            break
        case .Downloading:
            self.loadingView.status = NSLocalizedString("Downloading...", comment: "")
            break
        case .Finalizing:
            self.loadingView.status = NSLocalizedString("Finalizing...", comment: "")
            break
        case .None:
            self.loadingView.status = ""
            break
        }
    }
    
    func musicClient(downloader: MusicDownloaderClient, didCompleteWithError error: NSError?)
    {
        self.showMainControl()
        self.showErrorAlertWithMessage(error!.localizedDescription)
    }
    
    func musicClient(downloader: MusicDownloaderClient, didFinishDownloadingToURL location: NSURL)
    {
        self.showMainControl()

        do {
            let fh = try NSFileHandle(forReadingFromURL: location)
            let fileData = fh.availableData
            ModelFacad.saveAudioWithTitle(self.musicTitle, andCategory: self.musicCategory, withData: fileData)
            SoundfullNotificationManager.sharedManager.scheduleNotification()
 
        }
        catch _ {
            self.showErrorAlertWithMessage(NSLocalizedString("Could not save audio", comment: ""))
        }
    }
        
}