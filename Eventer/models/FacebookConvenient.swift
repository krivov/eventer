//
//  FacebookConvenient.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import CoreData

extension FacebookClient {
    
    //search facebook event by search string
    func searchEvents(text: String, completionHandler: (events: [Event], error: NSError?) -> Void) {
        
        fbGraphSearchEvents(text) { (result, error) -> Void in
            if let error = error {
                completionHandler(events: [], error: error)
            } else {
                
                var events : [Event] = []
                
                for eventDictionary in result! {
                     let newEvent = Event(fbEventArray: eventDictionary, context: self.sharedContext)
                    
                    events.append(newEvent)
                }
                
                //Save the context
                dispatch_async(dispatch_get_main_queue(), {
                    CoreDataStackManager.sharedInstance().saveContext()
                })
                
                completionHandler(events: events, error: nil)
            }
        }
    }
    
    //download image by url and save in event
    func downloadImage(url: String, event: Event, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        taskForGETMethod(url) { (result, error) -> Void in
            if let error = error {
                
                event.cover!.filePath = "error"
                
                completionHandler(success: false, error: error)
            } else {
                
                if let result = result {
                    
                    if let imageUrl = NSURL(string: url) {
                        //get file name and file url
                        let fileName = imageUrl.lastPathComponent
                        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                        let pathArray = [dirPath, fileName!]
                        let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
                        
                        //save file
                        NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: result, attributes: nil)
                        
                        //update the Photo model
                        event.cover!.filePath = fileURL.path
                        
                        completionHandler(success: true, error: nil)
                    } else {
                        completionHandler(success: false, error: error)
                    }
                }
            }
        }
        
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
}
