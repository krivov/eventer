//
//  SearchViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 30.09.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
    }
    
    @IBAction func touchSearchButton(sender: UIButton) {
        startLoading()
        
        FacebookClient.sharedInstance.searchEvents(searchField.text!) { (events, error) -> Void in
            
            if let error = error {
                print(error.description)
                self.stopLoading()
            } else {
                print("ok")
                self.performSegueWithIdentifier("showResultsSeque", sender: self)
            }
        }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        touchSearchButton(searchButton)
        return true
    }
    
    @IBAction func changeSearchTextField(sender: UITextField) {
        let countCharacter = searchField.text?.characters.count
        
        if countCharacter > 0 {
            searchButton.enabled = true
        } else {
            searchButton.enabled = false
        }
    }
}

