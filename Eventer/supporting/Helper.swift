//
//  Helper.swift
//  Eventer
//
//  Created by Sergey Krivov on 11.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class Helper {
    
    //show alert
    static func showAlert(controller: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        )
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
