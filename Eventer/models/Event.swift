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

class Event: NSManagedObject, MKAnnotation {

    //event facebook id
    @NSManaged var id: Int64
    
    //Number of people attending the event
    @NSManaged var attending_count: Int32
    
    //Event location city
    @NSManaged var city: String?
    
    //Event location country
    @NSManaged var country: String?
    
    //Number of people who declined the event
    @NSManaged var declined_count: Int32
    
    //Event description
    @NSManaged var descr: String?
    
    //End time, if one has been set
    @NSManaged var end_time: NSDate?
    
    //Event location latitude
    @NSManaged var latitude: Double
    
    //Event location longitude
    @NSManaged var longitude: Double
    
    //Number of people who maybe going to the event
    @NSManaged var maybe_count: Int32
    
    //Event name
    @NSManaged var name: String
    
    //Number of people who did not reply to the event
    @NSManaged var noreply_count: Int32
    
    //The profile id that created the event
    @NSManaged var owner_id: Int64
    
    //The profile name that created the event
    @NSManaged var owner_name: String?
    
    //Event Place
    @NSManaged var place: String?
    
    //Start time
    @NSManaged var start_time: NSDate?
    
    //Event location street
    @NSManaged var street: String?
    
    //The link users can visit to buy a ticket to this event
    @NSManaged var ticket_uri: String?
    
    //is event save to favorite
    @NSManaged var is_favorite: Bool
    
    //is event in currebt search
    @NSManaged var current_search: Bool
    
    //Cover picture
    @NSManaged var cover: Photo?
    
    //variables for map annotation
    var title: String?
    var subtitle: String?
    
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
    
    //init event object from dictionary
    init(fbEventArray: [String: AnyObject], context: NSManagedObjectContext) {
        
        // Entity of core data
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        if let attending_count = fbEventArray["attending_count"] as? Int {
            self.attending_count = Int32(attending_count)
        }
        
        if let id = fbEventArray["id"] as? String {
            self.id = Int64(id)!
        }
        
        if let name = fbEventArray["name"] as? String {
            self.name = name
            self.title = name
        }
        
        if let declined_count = fbEventArray["declined_count"] as? Int {
            self.declined_count = Int32(declined_count)
        }
        
        if let descr = fbEventArray["description"] as? String {
            self.descr = descr
            self.subtitle = descr
        }
        
        if let end_time = fbEventArray["end_time"] as? String {
            if let end_time_nsdate = dateFormatter.dateFromString(end_time) {
                self.end_time = end_time_nsdate
            }
        }
        
        if let start_time = fbEventArray["start_time"] as? String {
            if let start_time_nsdate = dateFormatter.dateFromString(start_time) {
                self.start_time = start_time_nsdate
            }
        }
        
        if let placeDict = fbEventArray["place"] as? [String: AnyObject] {
            if let place = placeDict["name"] as? String {
                self.place = place
            }
            
            if let locationDict = placeDict["location"] as? [String: AnyObject] {
                if let city = locationDict["city"] as? String {
                    self.city = city
                }
                
                if let country = locationDict["country"] as? String {
                    self.country = country
                }
                
                if let street = locationDict["street"] as? String {
                    self.street = street
                }
                
                if let latitude = locationDict["latitude"] as? Double {
                    self.latitude = latitude
                }
                
                if let longitude = locationDict["longitude"] as? Double {
                    self.longitude = longitude
                }
            }
        }
        
        if let maybe_count = fbEventArray["maybe_count"] as? Int {
            self.maybe_count = Int32(maybe_count)
        }
        
        if let noreply_count = fbEventArray["noreply_count"] as? Int {
            self.noreply_count = Int32(noreply_count)
        }
        
        if let ownerDict = fbEventArray["owner"] as? [String: AnyObject] {
            if let owner_id = ownerDict["id"] as? String {
                self.owner_id = Int64(owner_id)!
            }
            
            if let owner_name = ownerDict["name"] as? String {
                self.owner_name = owner_name
            }
        }
        
        if let ticket_uri = fbEventArray["ticket_uri"] as? String {
            self.ticket_uri = ticket_uri
        }
        
        if let coverDict = fbEventArray["cover"] as? [String: AnyObject] {
            if let photoUrl = coverDict["source"] as? String {
                let newPhoto = Photo(photoURL: photoUrl, event: self, context: context)
                self.cover = newPhoto
            }
        }
        
        self.is_favorite = false;
        self.current_search = true;
    }
}
