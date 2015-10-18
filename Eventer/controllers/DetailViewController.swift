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
    
    var cells:[UITableViewCell] = []
    var cellHeights:[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = event.cover?.image {
            eventImage.image = image
        } else {
            if let imageUrl = event.cover?.url {
                //Get image for photo object, and save the context
                FacebookClient.sharedInstance.downloadImage(imageUrl, event: event, completionHandler: { (success, error) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        CoreDataStackManager.sharedInstance().saveContext()
                        if let image = self.event.cover?.image {
                            self.eventImage.image = image
                        }
                    })
                })
            }
        }
        
        nameLabel.text = event.name
        self.setAllCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if let cell = self.cells[row] as? UITableViewCell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        if let height = cellHeights[row] as? CGFloat {
            return height
        } else {
            return 0
        }
    }
    
    func setAllCells() {
        
        self.cells = []
        self.cellHeights = []
        
        if let datesCell = self.tableView.dequeueReusableCellWithIdentifier("datesCell") as? DatesTableViewCell {
            
            datesCell.fillCell(event)
            
            self.cells.append(datesCell)
            self.cellHeights.append(70)
        }
        
        if let locationCell = self.tableView.dequeueReusableCellWithIdentifier("locationCell") as? LocationTableViewCell {
            
            locationCell.fillCell(event)
            
            self.cells.append(locationCell)
            self.cellHeights.append(185)
        }
        
        if (event.descr != nil) {
            if let descriptionCell = self.tableView.dequeueReusableCellWithIdentifier("descriptionCell") as? DescriptionTableViewCell {
                
                descriptionCell.setDescrText(event.descr!)
                
                self.cells.append(descriptionCell)
                self.cellHeights.append(descriptionCell.getDescrTextHeight(event.descr!))
            }
        }
        
        if let ownerId = event.owner_id as? Int64, ownerName = event.owner_name {
            if let ownerCell = self.tableView.dequeueReusableCellWithIdentifier("ownerCell") as? OwnerTableViewCell {
                
                ownerCell.ownerButton.setTitle(event.owner_name, forState: UIControlState.Normal)
                ownerCell.ownerId = event.owner_id
                
                self.cells.append(ownerCell)
                self.cellHeights.append(42)
            }
        }
        
        if let ticketUrl = event.ticket_uri {
            if let ticketCell = self.tableView.dequeueReusableCellWithIdentifier("ticketCell") as? TicketTableViewCell {
                
                ticketCell.ticketUrl = event.ticket_uri
                
                self.cells.append(ticketCell)
                self.cellHeights.append(42)
            }
        }
        
        if let countsCell = self.tableView.dequeueReusableCellWithIdentifier("countsCell") as? CountsTableViewCell {
            
            countsCell.fillCount(event)
            
            self.cells.append(countsCell)
            self.cellHeights.append(130)
        }
    }
}
