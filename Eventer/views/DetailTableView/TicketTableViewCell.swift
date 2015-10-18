//
//  TicketTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    //event buy ticket url
    var ticketUrl: String?

    //open ticket url in browser
    @IBAction func buyTicketButtonTouch(sender: AnyObject) {
        if ticketUrl != nil {
            if let url = NSURL(string: ticketUrl!) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
