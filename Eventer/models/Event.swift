//
//  FacebookEvent.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@objc(Event)

class Event: NSManagedObject {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var title: String
    @NSManaged var descr: String
    @NSManaged var photos: NSMutableOrderedSet
    
    var coordinate: CLLocationCoordinate2D {
        
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
        
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }

    // MARK: - Init model
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        
        // Entity of core data
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.photos = NSMutableOrderedSet()
    }
}
