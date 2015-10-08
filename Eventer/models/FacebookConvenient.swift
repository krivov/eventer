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
            print(result)
        }
        
        
        
        //Make GET request for get photos for pin
//        taskForGETMethodWithParameters(parameters, completionHandler: {
//            results, error in
//            
//            if let error = error {
//                completionHandler(success: false, error: error)
//            } else {
//                
//                //response dictionary
//                if let photosDictionary = results.valueForKey(JSONResponseKeys.Photos) as? [String: AnyObject],
//                    photosArray = photosDictionary[JSONResponseKeys.Photo] as? [[String : AnyObject]],
//                    numberOfPhotoPages = photosDictionary[JSONResponseKeys.Pages]     as? Int {
//                        
//                        pin.pageNumber = numberOfPhotoPages
//                        
//                        //dictionary with photos
//                        for photoDictionary in photosArray {
//                            
//                            let photoURLString = photoDictionary[URLValues.URLMediumPhoto] as! String
//                            
//                            //create Photo model
//                            let newPhoto = Photo(photoURL: photoURLString, pin: pin, context: self.sharedContext)
//                            
//                            //download photo by url
//                            self.downloadPhotoImage(newPhoto, completionHandler: {
//                                success, error in
//                                
//                                //Save the context
//                                dispatch_async(dispatch_get_main_queue(), {
//                                    CoreDataStackManager.sharedInstance().saveContext()
//                                })
//                            })
//                        }
//                        
//                        completionHandler(success: true, error: nil)
//                } else {
//                    
//                    completionHandler(success: false, error: NSError(domain: "downloadPhotosForPin", code: 0, userInfo: nil))
//                }
//            }
//        })
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
}
