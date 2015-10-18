//
//  EventSearchTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 08.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class EventSearchTableViewCell: UITableViewCell {

    //event object
    var event: Event!
    
    //labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //event image
    @IBOutlet weak var locationImage: UIImageView!
    
    //add to favorite button
    @IBOutlet weak var favoriteButton: UIButton!
    
    //add to favorite
    @IBAction func addToFavorite(sender: UIButton) {
        if(self.event.is_favorite) {
            event.is_favorite = false
        } else {
            event.is_favorite = true
            event.current_search = false
        }
        
        //set favorite button image
        setFavoriteButtonImage()
        
        dispatch_async(dispatch_get_main_queue(), {
            CoreDataStackManager.sharedInstance().saveContext()
        })
    }
    
    //set favorite buuton (if event is favorite or not)
    func setFavoriteButtonImage() {
        var imageName = ""
        
        if self.event.is_favorite {
            imageName = "add_favorite_select"
        } else {
            imageName = "add_favorite"
        }
        
        favoriteButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }
}
