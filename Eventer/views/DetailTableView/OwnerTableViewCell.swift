//
//  OwnerTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class OwnerTableViewCell: UITableViewCell {
    
    var ownerId: Int64?

    @IBOutlet weak var ownerButton: UIButton!
    
    @IBAction func ownerButtonTouch(sender: AnyObject) {
        if ownerId != nil {
            //if let url = NSURL(string: "fb://profile/\(ownerId!)") {
            if let url = NSURL(string: "http://facebook.com/\(ownerId!)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
