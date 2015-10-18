//
//  DatesTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class DatesTableViewCell: UITableViewCell {
    
    //labels
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    
    //fill cell with event data
    func fillCell(event: Event) {
        
        //set format of date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mma"
        dateFormatter.timeZone = NSTimeZone()
        
        //set date of event start
        if (event.start_time != nil) {
            dateStartLabel.text = dateFormatter.stringFromDate(event.start_time!)
        } else {
            startLabel.hidden = true
            dateStartLabel.hidden = true
        }
        
        //set date of event end
        if (event.end_time != nil) {
            dateEndLabel.text = dateFormatter.stringFromDate(event.end_time!)
        } else {
            endLabel.hidden = true
            dateEndLabel.hidden = true
        }
    }
    
}
