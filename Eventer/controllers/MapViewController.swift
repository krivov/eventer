//
//  MapViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 01.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set mapView delegate
        self.mapView.delegate = self
        
        //show the user’s location on the map
        self.mapView.showsUserLocation = true

        // Load all pre-saved Pins from CoreData
        self.mapView.addAnnotations(self.fetchSearchEvents())
        
        //load previous map view region properties
        self.loadMapViewRegion()
    }
    
    override func viewWillAppear(animated: Bool) {
        //hide navigation bar
        self.navigationController?.navigationBarHidden = true
    }

    // ====================================================================================
    // MARK: - Core Data
    
    // CoreData sharedContext
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // fetch all events from CoreData that current search
    func fetchSearchEvents() -> [Event] {
        
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        fetchRequest.predicate = NSPredicate(format: "current_search == %@ AND latitude != 0 AND longitude != 0", true)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        
        let results: [AnyObject]?
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error.memory = error1
            results = nil
        }
        
        if error != nil {
            Helper.showAlert(self, title: "Error", message: "There was an error getting events")
        }
        
        return results as! [Event]
    }
    
    
    // ====================================================================================
    // MARK: - NSUserDefaults constants and methods
    
    let CenterLatitudeMapView     = "Center Latitude"
    let CenterLongitudeMapView    = "Center Longitude"
    let SpanLatitudeDeltaMapView  = "Span Latitude Delta"
    let SpanLongitudeDeltaMapView = "Span Longitude Delta"
    
    //Save mapView region properties to NSUserDefaults
    func saveMapViewRegion() {
        NSUserDefaults.standardUserDefaults().setDouble(mapView.region.center.latitude, forKey: CenterLatitudeMapView)
        NSUserDefaults.standardUserDefaults().setDouble(mapView.region.center.longitude, forKey: CenterLongitudeMapView)
        NSUserDefaults.standardUserDefaults().setDouble(mapView.region.span.latitudeDelta, forKey: SpanLatitudeDeltaMapView)
        NSUserDefaults.standardUserDefaults().setDouble(mapView.region.span.longitudeDelta, forKey: SpanLongitudeDeltaMapView)
    }
    
    //Reload mapView region properties from NSUserDefaults
    func loadMapViewRegion() {
        
        //if mapView region properties exist in NSUserDefaults - zoom map to save location
        let centerLatitude = NSUserDefaults.standardUserDefaults().doubleForKey(CenterLatitudeMapView)
        
        if centerLatitude != 0 {
            
            //Get all map view region properties
            let centreLongitude = NSUserDefaults.standardUserDefaults().doubleForKey(CenterLongitudeMapView)
            let spanLatitudeDelta = NSUserDefaults.standardUserDefaults().doubleForKey(SpanLatitudeDeltaMapView)
            let spanLongitudeDelta = NSUserDefaults.standardUserDefaults().doubleForKey(SpanLongitudeDeltaMapView)
            
            let center = CLLocationCoordinate2DMake(centerLatitude, centreLongitude)
            let span = MKCoordinateSpanMake(spanLatitudeDelta, spanLongitudeDelta)
            
            //set properties to map view
            let region = MKCoordinateRegionMake(center, span)
            mapView.region = region
        }
    }
    
    // ====================================================================================
    // MARK: - MKMapViewDelegate implementation
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        //Save map view region properties
        saveMapViewRegion()
    }
    
    
    //set view for map annotations
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        //Use dequeued pin annotation view if available, otherwise create a new one
        if let annotation = annotation as? Event {
            
            let identifier = "EventMapView"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.animatesDrop = true
                view.draggable = false
                
                let rightButton:UIButton = UIButton(type: UIButtonType.InfoDark)
                rightButton.alpha = 0
                view.rightCalloutAccessoryView = rightButton
            }
            
            return view
        }
        
        return nil
    }
    
    //touch to annotation view
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //show detail event controller
        if let event = view.annotation as? Event {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            
            controller.event = event
            
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
    }
}
