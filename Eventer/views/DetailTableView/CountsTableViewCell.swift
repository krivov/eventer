//
//  CountsTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class CountsTableViewCell: UITableViewCell {

    @IBOutlet weak var attendingLabel: UILabel!
    @IBOutlet weak var maybeLabel: UILabel!
    @IBOutlet weak var declinedLabel: UILabel!
    @IBOutlet weak var didNotReplayLabel: UILabel!
    
    func fillCount(event: Event) {
        attendingLabel.text = String(event.attending_count)
        maybeLabel.text = String(event.maybe_count)
        declinedLabel.text = String(event.declined_count)
        didNotReplayLabel.text = String(event.noreply_count)
    }
    
}
