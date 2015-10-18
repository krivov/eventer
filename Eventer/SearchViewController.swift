//
//  SearchViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 30.09.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITextFieldDelegate {

    //search text field
    @IBOutlet weak var searchField: UITextField!
    
    //search button
    @IBOutlet weak var searchButton: UIButton!
    
    //activity indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set search field delegate
        searchField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //get all events from core data which isn't favorite and delete them
        dispatch_async(dispatch_get_main_queue(), {
            let error: NSErrorPointer = nil
            let fetchRequest = NSFetchRequest(entityName: "Event")
            
            let predicateIsFavorite = NSPredicate(format: "is_favorite != %@", argumentArray: [true])
            fetchRequest.predicate = predicateIsFavorite
            
            let results: [AnyObject]?
            do {
                results = try self.sharedContext.executeFetchRequest(fetchRequest)
            } catch let error1 as NSError {
                error.memory = error1
                results = nil
            }
            
            if results != nil {
                var events = results as! [Event]
                
                for event: AnyObject in events
                {
                    self.sharedContext.deleteObject(event as! NSManagedObject)
                }
                
                events.removeAll(keepCapacity: false)
            }
            
            CoreDataStackManager.sharedInstance().saveContext()
        })
    }
    
    //search events
    @IBAction func touchSearchButton(sender: UIButton) {
        
        startLoading()
        
        FacebookClient.sharedInstance.searchEvents(searchField.text!) { (events, error) -> Void in
            
            if let error = error {
                print(error.description)
                self.stopLoading()
            } else {
                print("ok")
                self.performSegueWithIdentifier("showResultsSeque", sender: self)
            }
        }
    }
    
    //prepare for loading events (disable search field, start active indicator, hide button)
    func startLoading() {
        self.searchButton.hidden = true;
        self.activityIndicator.startAnimating()
        self.searchField.enabled = false
    }
    
    //prepare for stop loading events (enable search field, stop active indicator, show button)
    func stopLoading() {
        self.searchButton.hidden = false;
        self.activityIndicator.stopAnimating()
        self.searchField.enabled = true
    }
    
    //search events when touch return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        touchSearchButton(searchButton)
        return true
    }
    
    //enable and disable button when typing text
    @IBAction func changeSearchTextField(sender: UITextField) {
        let countCharacter = searchField.text?.characters.count
        
        if countCharacter > 0 {
            searchButton.enabled = true
        } else {
            searchButton.enabled = false
        }
    }
    
    //=====================================================================
    //MARK: Core Data
    
    // CoreData sharedContext
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
}

