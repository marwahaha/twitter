//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileBannerImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet var followerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        profileImageView.layer.cornerRadius = 3
        profileImageView.layer.backgroundColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 5
        profileImageView.clipsToBounds = true
        profileImageView.layer.zPosition = 100
        
        let id = User.currentUser?.id!
        
        let client = TwitterClient.sharedInstance
        
        client.user(id!, params: nil) { (user) -> () in
            client.safeSetImageWithURL(self.profileImageView, imagePath: NSURL(string: user.profileImageUrl!))
            client.safeSetImageWithURL(self.profileBannerImageView, imagePath: NSURL(string: user.profileBannerUrl!))
            self.nameLabel.text = user.name
            self.screenNameLabel.text = "@" + user.screenName!
            self.bioLabel.text = user.tagline
            self.followerCountLabel.text = user.followerCountString
            self.followingCountLabel.text = user.followingCountString
        }
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
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
