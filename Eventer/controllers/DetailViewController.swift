//
//  DetailViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 01.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //table with event data
    @IBOutlet weak var tableView: UITableView!
    
    //event title
    @IBOutlet weak var nameLabel: UILabel!
    
    //event cover
    @IBOutlet weak var eventImage: UIImageView!
    
    //event to show
    var event: Event!
    
    //cells with event data
    var cells:[UITableViewCell] = []
    //cells height
    var cellHeights:[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set event image or download and set
        if let image = event.cover?.image {
            eventImage.image = image
        } else {
            if let imageUrl = event.cover?.url {
                //Get image for event object, and save the context
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
        
        //set event title
        nameLabel.text = event.name
        
        //fill all cells
        self.setAllCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        //show navigation bar
        self.navigationController?.navigationBarHidden = false
    }
    
    //set number of rows in table from cells array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count;
    }
    
    //set table cells from cells array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if let cell = self.cells[row] as? UITableViewCell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //set table cells height from cells height array
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        if let height = cellHeights[row] as? CGFloat {
            return height
        } else {
            return 0
        }
    }
    
    //fill cells with event data
    func setAllCells() {
        
        self.cells = []
        self.cellHeights = []
        
        //set dates information
        if let datesCell = self.tableView.dequeueReusableCellWithIdentifier("datesCell") as? DatesTableViewCell {
            
            datesCell.fillCell(event)
            
            self.cells.append(datesCell)
            self.cellHeights.append(70)
        }
        
        //set location information
        if let locationCell = self.tableView.dequeueReusableCellWithIdentifier("locationCell") as? LocationTableViewCell {
            
            locationCell.fillCell(event)
            
            self.cells.append(locationCell)
            self.cellHeights.append(185)
        }
        
        //set description information
        if (event.descr != nil) {
            if let descriptionCell = self.tableView.dequeueReusableCellWithIdentifier("descriptionCell") as? DescriptionTableViewCell {
                
                descriptionCell.setDescrText(event.descr!)
                
                self.cells.append(descriptionCell)
                self.cellHeights.append(descriptionCell.getDescrTextHeight(event.descr!))
            }
        }
        
        //set owner name and button
        if let ownerId = event.owner_id as? Int64, ownerName = event.owner_name {
            if let ownerCell = self.tableView.dequeueReusableCellWithIdentifier("ownerCell") as? OwnerTableViewCell {
                
                ownerCell.ownerButton.setTitle(event.owner_name, forState: UIControlState.Normal)
                ownerCell.ownerId = event.owner_id
                
                self.cells.append(ownerCell)
                self.cellHeights.append(42)
            }
        }
        
        //set ticket button
        if let ticketUrl = event.ticket_uri {
            if let ticketCell = self.tableView.dequeueReusableCellWithIdentifier("ticketCell") as? TicketTableViewCell {
                
                ticketCell.ticketUrl = event.ticket_uri
                
                self.cells.append(ticketCell)
                self.cellHeights.append(42)
            }
        }
        
        //set counts information
        if let countsCell = self.tableView.dequeueReusableCellWithIdentifier("countsCell") as? CountsTableViewCell {
            
            countsCell.fillCount(event)
            
            self.cells.append(countsCell)
            self.cellHeights.append(130)
        }
    }
}
