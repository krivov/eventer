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
    var deletedIndexPaths : [NSIndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //don't show empty cell
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.clearColor()
        
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
        
        //add button for new search
        let backButton = UIBarButtonItem(title: "New search", style: UIBarButtonItemStyle.Done, target: self, action: "backButton")
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    //show new search controller
    func backButton() {
        self.performSegueWithIdentifier("listNewSearch", sender: self)
    }
    
    //=====================================================================
    //MARK: TableView
    
    //set number of rows in table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
                return sectionInfo.numberOfObjects
            }
        }
        
        return 0
    }
    
    //set table cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        let CellIdentifier = "EventSearchCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! EventSearchTableViewCell
        
        //configure cell fields
        cell.event = event
        cell.setFavoriteButtonImage()
        
        cell.nameLabel.text = event.name
        
        if event.city != nil && event.country != nil {
            cell.locationLabel.text = "\(event.city!) \(event.country!)"
        } else {
            cell.locationLabel.hidden = true
            cell.locationImage.hidden = true
        }
        
        if event.start_time != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.timeZone = NSTimeZone()
            
            cell.dateLabel.text = dateFormatter.stringFromDate(event.start_time!)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //show controller with detail event information
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        controller.event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        self.navigationController!.pushViewController(controller, animated: true)
    }

    //=====================================================================
    //MARK: Core Data
    
    // CoreData sharedContext
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create fetch request for events which current search.
        let fetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "current_search == %@", true)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        
        //Create fetched results controller with the new fetch request.
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        }()

}
