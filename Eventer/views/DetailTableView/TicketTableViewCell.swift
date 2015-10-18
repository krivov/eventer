//
//  TicketTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    var ticketUrl: String?

    @IBAction func buyTicketButtonTouch(sender: AnyObject) {
        if ticketUrl != nil {
            if let url = NSURL(string: ticketUrl!) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
