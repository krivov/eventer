//
//  FavoritesViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 01.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Arrays with selected and deleted indexes of table view cells
    var selectedIndexes   = [NSIndexPath]()
    var deletedIndexPaths : [NSIndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView?.hidden = true
        
        //initial fetch
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if (error != nil) {
            Helper.showAlert(self, title: "Error", message: "Error of displaing events")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        tableView.reloadData()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        let CellIdentifier = "EventSearchCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! EventSearchTableViewCell
        
        cell.event = event
        
        cell.nameLabel.text = event.name
        
        if event.city != nil && event.country != nil {
            cell.locationLabel.text = "\(event.city!) \(event.country!)"
        } else {
            cell.locationLabel.hidden = true
            cell.locationImage.hidden = true
        }
        
        if event.start_time != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy'"
            dateFormatter.timeZone = NSTimeZone()
            
            cell.dateLabel.text = dateFormatter.stringFromDate(event.start_time!)
        }
        
        //cell.dateLabel.text = event.start_time
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        controller.event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            //tableView.beginUpdates()
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            //tableView.endUpdates()
            let event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
            
            // Remove the row from the table
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            // Remove the actor from the array
            self.sharedContext.deleteObject(event)
            
            dispatch_async(dispatch_get_main_queue(), {
                CoreDataStackManager.sharedInstance().saveContext()
            })
        default:
            break
        }
    }
    

    //=====================================================================
    //MARK: Core Data
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create fetch request for photos which match the sent Pin.
        let fetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "is_favorite == %@", true)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        
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
        
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        //add indexPath to appropriate array with type of change
        switch type {
        case .Insert:
            print("INSERT")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            deletedIndexPaths.append(indexPath!)
        case .Update:
            print("UPDATE")
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        //Check to make sure UI elements are correctly displayed.
        if controller.fetchedObjects?.count > 0 {
            //TODO: enable edit button
        }
        
        print("controllerDidChangeContent")
        tableView.endUpdates()
        
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
