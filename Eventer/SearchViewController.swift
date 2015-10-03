//
//  SearchViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 30.09.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func touchSearchButton(sender: UIButton) {
        startLoading()
        
    }
    
    func startLoading() {
        self.searchButton.hidden = true;
        self.activityIndicator.startAnimating()
        self.searchField.enabled = false
    }
    
    func stopLoading() {
        self.searchButton.hidden = true;
        self.activityIndicator.startAnimating()
        self.searchField.enabled = true
    }


}

