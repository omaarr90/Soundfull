//
//  DownloadMusicViewController.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/5/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit

protocol DownloadMusicViewControllerDelegate {
    func didClickDownloadWithValidURL(urlSring: String, andTitle title: String, andCategory category: String, forViewController viewController: UIViewController)
}

class DownloadMusicViewController: UIViewController {
    @IBOutlet weak var downloadMusicLabel: UILabel!
    @IBOutlet weak var urlTextField: SoundfullTextField!
    @IBOutlet weak var downloadButton: SoundfullButton!
    
    @IBOutlet weak var categoryTextField: SoundfullTextField!
    
    @IBOutlet weak var titleTextField: SoundfullTextField!
    
    @IBOutlet weak var bottomButtunConstraints: NSLayoutConstraint!
    
    var delegate: DownloadMusicViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadMusicLabel.text = NSLocalizedString("Download Sound", comment: "")
        self.urlTextField.soundfullPlaceholder = NSLocalizedString("Paste URL", comment: "")
        self.titleTextField.soundfullPlaceholder = NSLocalizedString("Title", comment: "")
        self.categoryTextField.soundfullPlaceholder = NSLocalizedString("Category", comment: "")
        self.downloadButton.setTitle("Download", forState: .Normal)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(note: NSNotification) {
        let info = note.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double

        self.bottomButtunConstraints.constant = keyboardFrame.size.height + 10

        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })

    }

    func keyboardWillHide(note: NSNotification) {
        self.bottomButtunConstraints.constant = 40
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })

    }

    @IBAction func downloadButtonClicked(sender: SoundfullButton, forEvent event: UIEvent)
    {
        if validateInput() {
            self.delegate?.didClickDownloadWithValidURL(self.urlTextField.text!, andTitle: self.titleTextField.text!, andCategory: self.categoryTextField.text!, forViewController: self)
        }
    }
    
    private func validateInput() -> Bool {
        return validateURL() && validateTitle() && validateCategory()
    }
    
    private func validateURL() -> Bool {
        if self.urlTextField.text?.isEmpty == true {
            self.showErrorAlertWithMessage(NSLocalizedString("Please provide a URL", comment: ""))
            return false
        } else if !self.urlTextField.text!.isValidURLString() {
            self.showErrorAlertWithMessage(NSLocalizedString("Please provide a valid URL", comment: ""))
            return false
        }
        return true
    }
    
    private func validateTitle() -> Bool {
        if self.titleTextField.text?.isEmpty == true {
            self.showErrorAlertWithMessage(NSLocalizedString("Please provide a title", comment: ""))
            return false
        }
        
        return true
    }
    
    private func validateCategory() -> Bool {
        if self.categoryTextField.text?.isEmpty == true {
            self.showErrorAlertWithMessage(NSLocalizedString("Please provide a category", comment: ""))
            return false
        }
        
        return true
    }
    
}
