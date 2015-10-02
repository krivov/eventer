//
//  LoginViewController.swift
//  Eventer
//
//  Created by Sergey Krivov on 02.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup facebook login button
        facebookButton.readPermissions = ["public_profile"]
        facebookButton.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        //acivate seque if we already loggin
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            self.performSegueWithIdentifier("afterLoginSeque", sender: self)
        }
    }
    
    //action with callback after login in facebook
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if (!result.isCancelled) {
            self.performSegueWithIdentifier("afterLoginSeque", sender: self)
        }
    }
    
    //touch to logout button
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("LogOut")
    }
}
