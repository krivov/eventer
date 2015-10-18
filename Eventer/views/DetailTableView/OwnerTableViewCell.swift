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
            if !UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/\(ownerId!)")!) {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://facebook.com/\(ownerId!)")!)
            }
        }
    }
}
