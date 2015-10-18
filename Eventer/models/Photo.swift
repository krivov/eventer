//
//  Photo.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import CoreData

@objc(Photo)

class Photo: NSManagedObject {
    //MARK: - Photo model properties
    
    @NSManaged var url: String
    @NSManaged var filePath: String?
    @NSManaged var event: Event
    
    var image: UIImage? {
        
        if let filePath = filePath {
            
            // Check to see if there's an error downloading the images for each Pin
            if filePath == "error" {
                return nil
            }
            
            // Get the file path
            //let fileName = filePath.lastPathComponent
            let fileNameUrl = NSURL(fileURLWithPath: filePath)
            
            if let fileName = fileNameUrl.lastPathComponent {
                let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                let pathArray = [dirPath, fileName]
                let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
                
                return UIImage(contentsOfFile: fileURL.path!)
            }
        }
        return nil
    }
    
    //MARK: - Init model
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(photoURL: String, event: Event, context: NSManagedObjectContext) {
        
        //Entity of core data
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.url = photoURL
        self.event = event
    }
    
    //MARK: - Delete file when delete managed object
    
    override func prepareForDeletion() {
        
        let fileNameUrl = NSURL(fileURLWithPath: filePath!)
        
        if let fileName = fileNameUrl.lastPathComponent {
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let pathArray = [dirPath, fileName]
            let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
            
            do {
                try NSFileManager.defaultManager().removeItemAtURL(fileURL)
            } catch _ {
                
            }
        }
    }

}
