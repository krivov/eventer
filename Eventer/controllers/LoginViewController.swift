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

        facebookButton.readPermissions = ["public_profile"]
        facebookButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("OK")
        if (!result.isCancelled) {
            print("token = " + result.token.tokenString)
            
            self.performSegueWithIdentifier("afterLoginSeque", sender: self)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("LogOut")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
