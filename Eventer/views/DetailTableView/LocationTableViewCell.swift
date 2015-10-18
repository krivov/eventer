//
//  LocationTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell, MKMapViewDelegate {

    //map view
    @IBOutlet weak var mapView: MKMapView!
    
    //labels
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    //fill cell with event data
    func fillCell(event: Event) {
        
        //set mapView delegate
        self.mapView.delegate = self
        
        //show the user’s location on the map
        self.mapView.showsUserLocation = true
        
        //if set event location - set center and region map
        if let latitude = event.latitude as? Double, longitude = event.longitude as? Double {
            
            self.mapView.addAnnotation(event)
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            
            //set properties to map view
            let region = MKCoordinateRegionMake(event.coordinate, span)
            mapView.region = region
        }
        
        //set place name
        placeLabel.text = event.place
        
        //set city and country name
        var cityCountry = event.city
        
        if (event.country != nil) {
            if (cityCountry != nil) {
                cityCountry = "\(cityCountry!), "
            }
            
            cityCountry = "\(cityCountry!)\(event.country!)"
        }
        
        cityCountryLabel.text = cityCountry
        
        //set address
        eventAddressLabel.text = event.street
    }

}
