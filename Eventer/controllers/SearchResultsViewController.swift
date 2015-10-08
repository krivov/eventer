//
//  SearchResultsViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 01.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Arrays with selected and deleted indexes of table view cells
    var selectedIndexes   = [NSIndexPath]()
    var deletedIndexPaths : [NSIndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //initial fetch
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if (error != nil) {
            showAlertWithTitleAndRetry("Error", message: "Error download photos for the selected pin", retryNewPhotoSet: false)
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func newSearchTouch(sender: UIButton) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //show alert
    func showAlertWithTitleAndRetry(title: String, message: String, retryNewPhotoSet: Bool) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        )
        
        
        if retryNewPhotoSet {
            
            alert.addAction(
                UIAlertAction(
                    title: "Retry",
                    style: UIAlertActionStyle.Destructive,
                    handler: {
                        action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
            )
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //=====================================================================
    //MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
                return sectionInfo.numberOfObjects
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        let CellIdentifier = "EventSearchCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! EventSearchTableViewCell
        
        cell.nameLabel.text = event.name
        cell.locationLabel.text = "\(event.city) \(event.country)"
        
        //cell.dateLabel.text = event.start_time
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        controller.event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        switch (editingStyle) {
//        case .Delete:
//            let actor = actors[indexPath.row]
//            
//            // Remove the actor from the array
//            actors.removeAtIndex(indexPath.row)
//            
//            // Remove the row from the table
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
//            
//            // Remove the actor from the context
//            sharedContext.deleteObject(actor)
//            CoreDataStackManager.sharedInstance().saveContext()        default:
//            break
//        }
//    }
    

    //=====================================================================
    //MARK: Core Data
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create fetch request for photos which match the sent Pin.
        let fetchRequest = NSFetchRequest(entityName: "Event")
        //fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.sortDescriptors = []
        
        //Create fetched results controller with the new fetch request.
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //Set indexes for changed content from Core Data
        deletedIndexPaths  = [NSIndexPath]()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        //add indexPath to appropriate array with type of change
        switch type {
        case .Insert:
            print("INSERT")
        case .Delete:
            deletedIndexPaths.append(indexPath!)
        case .Update:
            print("UPDATE")
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        //Check to make sure UI elements are correctly displayed.
        //if controller.fetchedObjects?.count > 0 {
        //    newCollectionButton.enabled = true
        //}
        
        //Make the relevant updates to the collectionView once Core Data has finished its changes.
        
        
        
//        collectionView.performBatchUpdates({
//            
//            //for indexPath in self.insertedIndexPaths {
//            //    self.collectionView.insertItemsAtIndexPaths([indexPath])
//            //}
//            
//            for indexPath in self.deletedIndexPaths {
//                self.collectionView.deleteItemsAtIndexPaths([indexPath])
//            }
//            
//            //for indexPath in self.updatedIndexPaths {
//            //    self.collectionView.reloadItemsAtIndexPaths([indexPath])
//            //}
//            
//            }, completion: nil)
    }

}
