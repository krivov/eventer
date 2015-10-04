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

    @NSManaged var id: Double
    @NSManaged var attending_count: Double
    @NSManaged var city: Double
    @NSManaged var country: Double
    @NSManaged var declined_count: Double
    @NSManaged var descr: String
    @NSManaged var end_time: Double
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var maybe_count: Double
    @NSManaged var name: String
    @NSManaged var noreply_count: Double
    @NSManaged var owner_id: Double
    @NSManaged var owner_name: Double
    @NSManaged var place: Double
    @NSManaged var start_time: Double
    @NSManaged var street: Double
    @NSManaged var ticket_uri: Double
    
    @NSManaged var cover: Photo
    
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
    }
}
