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
        if let _ = self.loadingView {
        } else {
            self.loadingView = SoundfullLoadingView(frame: CGRectMake(0, 0, 300, 300))
            self.loadingView.center = view.center
            self.loadingView.loaderBackgroundColor = UIColor.clearColor()
            self.loadingView.loaderColor = UIColor.soundfullOrangeColor()
            self.loadingView.alpha = 0.0
        }
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
        
        smc.youtubeButton.addTarget(self, action: Selector("youTubeButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.linkButton.addTarget(self, action: Selector("linkButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.galleryButton.addTarget(self, action: Selector("galleryButtonClicked:"), forControlEvents: .TouchUpInside)
        smc.mySoundButton.addTarget(self, action: Selector("mysoundButtonClicked:"), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(smc)
        self.view.sendSubviewToBack(smc)
        
        let centerX = NSLayoutConstraint(item: smc, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: smc, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: smc, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 350)
        
        let heightConstraint = NSLayoutConstraint(item: smc, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 370)
        
        self.view.addConstraints([centerX, centerY, widthConstraint, heightConstraint])
        
        return smc
    }
    
    private func showMainControl() {
        self.initSoundfullLoadingView()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.soundfullMainControl.alpha = 1.0
            self.loadingView.alpha = 0.0
            }) { (finished) -> Void in
                self.loadingView.removeFromSuperview()
                self.loadingView = nil
        }
    }
    
    private func showLoadingView() {
        self.initSoundfullLoadingView()
        self.view.addSubview(self.loadingView)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.soundfullMainControl.alpha = 0.0
            self.loadingView.alpha = 1.0
            },completion: nil)
    }
}

//MARK: - IBActions
extension LandingViewController {
    func youTubeButtonClicked(button: UIButton) {
        self.performSegueWithIdentifier("downloadMusicSegue", sender: self)
    }
    
    func linkButtonClicked(button: UIButton) {
        self.performSegueWithIdentifier("downloadMusicSegue", sender: self)
    }
    
    func galleryButtonClicked(button: UIButton) {
        print("Coming soon")
    }
    
    func mysoundButtonClicked(button: UIButton) {
        self.performSegueWithIdentifier("showMusics", sender: self)
        print("show My sounds")
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
            self.loadingView.status = "\(Int(progress * 100)) % \r Downloaded"
        }
    }
    
    func musicClient(downloader: MusicDownloaderClient, didChangeStatus status: MusicDownloaderClientStatus)
    {
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

        if ModelFacad.saveAudioWithTitle(self.musicTitle, andCategory: self.musicCategory, atURL: location) {
            // send notifications
        } else {
            self.showErrorAlertWithMessage(NSLocalizedString("Could not save music", comment: ""))
        }
    }
}