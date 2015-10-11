//
//  EventSearchTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 08.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class EventSearchTableViewCell: UITableViewCell {

    var event: Event!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func addToFavorite(sender: UIButton) {
        if(self.event.is_favorite) {
            
        } else {
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
