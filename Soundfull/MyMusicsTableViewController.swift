//
//  MyMusicsTableViewController.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/11/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import CoreData

class MyMusicsTableViewController: UITableViewController {

    private var musics: [AudioFile]!
    private var selectedMusic: AudioFile!
    private var sorted = false
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let musicFetchReguest = NSFetchRequest(entityName: "AudioFile")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        musicFetchReguest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: musicFetchReguest,
            managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
            sectionNameKeyPath: "category",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = unsortedButton()
        
        self.tableView.registerNib(UINib(nibName: "MyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicCell")
        
        self.tableView.separatorStyle = .None
        
        self.title = NSLocalizedString("My Sounds", comment: "")
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func performFetch() {
        var predicate: NSPredicate?
        if self.sorted == true {
            predicate = NSPredicate(format: "isFavourite == YES")
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
        } catch{
        }
    }

    func favouriteIconClicked(button: UIBarButtonItem) {
        self.sorted = !self.sorted
        self.performFetch()
        self.tableView.reloadData()
        self.changeFavouriteIcon()
    }
    
    private func changeFavouriteIcon() {
        if self.sorted == true {
            self.navigationItem.rightBarButtonItem = self.sortedButton()
        } else {
            self.navigationItem.rightBarButtonItem = self.unsortedButton()
        }
    }
    
    private func unsortedButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "SoundApp_Heart_Bar_UnFilled"), style: .Plain, target: self, action: Selector("favouriteIconClicked:"))

    }
    
    private func sortedButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "SoundApp_Heart_Bar_Filled"), style: .Plain, target: self, action: Selector("favouriteIconClicked:"))

    }

    // MARK: - TableView Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicCell", forIndexPath: indexPath) as! MyMusicTableViewCell

        cell.configureCell()
        // Configure the cell...
        
        let music = fetchedResultsController.objectAtIndexPath(indexPath) as! AudioFile
        
        cell.titleLabel.text = music.title!
        cell.subtitleLabel.text = music.category!

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let music = fetchedResultsController.objectAtIndexPath(indexPath) as! AudioFile
        self.selectedMusic = music
        performSegueWithIdentifier("showMusicDetails", sender: self)
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let musicData = self.fetchedResultsController.objectAtIndexPath(indexPath) as! AudioFile
            
            let alert = UIAlertController(title: NSLocalizedString("Delete", comment: ""), message: NSLocalizedString("Are you sure you want to delete this audio?", comment: ""), preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
                musicData.MR_deleteEntity()
                let path = SoundfullFileManager.getMusicFilePathForName("\(musicData.title!)\(musicData.category!).m4a")
                SoundfullFileManager.deleteatPath(path)
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let musicDteailViewController = segue.destinationViewController as! MusicDetailsViewController
        
        musicDteailViewController.music = self.selectedMusic
    }

}


extension MyMusicsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            break
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Move: break
        case .Update: self.tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            break
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
        case .Update: break
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }

}