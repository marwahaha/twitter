//
//  ViewController.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/8/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken() // returns the user to a logged-out state, which is assumed in the following steps
        // Step 1: Get Request Token
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestCredential: BDBOAuth1Credential!) -> Void in
                print("Got the request credential: \(requestCredential.token)")
                // Step 2: Build Authorization Page URL with Token
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestCredential.token!)")!
                // (Outside of this code) Set up app to handle the callbackURL from the token request
                // This is where Twitter will redirect you after the authorization is complete (we want to go back to our app)
                UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                print("There was an error getting the request credentials: \(error.description)")
        }
    }

}

