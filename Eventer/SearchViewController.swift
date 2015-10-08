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

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            let error: NSErrorPointer = nil
            let fetchRequest = NSFetchRequest(entityName: "Event")
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
    
    func startLoading() {
        self.searchButton.hidden = true;
        self.activityIndicator.startAnimating()
        self.searchField.enabled = false
    }
    
    func stopLoading() {
        self.searchButton.hidden = true;
        self.activityIndicator.startAnimating()
        self.searchField.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        touchSearchButton(searchButton)
        return true
    }
    
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
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
}

