//
//  DescriptionTableViewCell.swift
//  Eventer
//
//  Created by Sergey Krivov on 17.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    //description text
    @IBOutlet weak var descriptionText: UITextView!
    
    //set description text and update frame height
    func setDescrText(text: String) {
        self.descriptionText.text = text
        
        var frame: CGRect = descriptionText.frame
        let cHeight: CGFloat = descriptionText.contentSize.height
        frame.size.height = cHeight + 8.0
        descriptionText.frame = frame
    }
    
    //get frame height by text
    func getDescrTextHeight(text: String) -> CGFloat {
        self.descriptionText.text = text
        
        let fixedWidth = descriptionText.frame.size.width
        descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = descriptionText.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        descriptionText.frame = newFrame;
        
        return newFrame.size.height + 8.0
    }
    
}
