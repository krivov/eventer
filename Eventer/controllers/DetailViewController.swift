//
//  DetailViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 01.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = event.name
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            if let datesCell = self.tableView.dequeueReusableCellWithIdentifier("datesCell") as? DatesTableViewCell {
                
                datesCell.fillCell(event)
                
                return datesCell
            }
        } else if row == 1 {
            if let locationCell = self.tableView.dequeueReusableCellWithIdentifier("locationCell") as? LocationTableViewCell {
                
                locationCell.fillCell(event)
                
                return locationCell
            }
        } else if row == 2 {
            if let descriptionCell = self.tableView.dequeueReusableCellWithIdentifier("descriptionCell") as? DescriptionTableViewCell {
                
                descriptionCell.setDescrText(event.descr!)
                
                return descriptionCell
            }
        } else if row == 3 {
            if let ownerCell = self.tableView.dequeueReusableCellWithIdentifier("ownerCell") as? OwnerTableViewCell {
                
                return ownerCell
            }
        } else if row == 4 {
            if let ticketCell = self.tableView.dequeueReusableCellWithIdentifier("ticketCell") as? TicketTableViewCell {
                
                return ticketCell
            }
        } else if row == 5 {
            if let countsCell = self.tableView.dequeueReusableCellWithIdentifier("countsCell") as? CountsTableViewCell {
                
                return countsCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        var height: CGFloat = 0
        
        switch row {
        case 0:
            height = 70
        case 1:
            height = 185
        case 2:
            if (event.descr != nil) {
                if let descriptionCell = self.tableView.dequeueReusableCellWithIdentifier("descriptionCell") as? DescriptionTableViewCell {
                    
                    height = descriptionCell.getDescrTextHeight(event.descr!)
                }
            } else {
                height = 0
            }
        case 3:
            height = 42
        case 4:
            height = 42
        case 5:
            height = 130
        default: break
        }
        
        return height
    }
}
