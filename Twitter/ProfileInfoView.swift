//
//  ProfileInfoView.swift
//  Twitter
//
//  Created by MediaLab on 2/18/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ProfileInfoView: UIView {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!

    var user: User? {
        didSet{
            let bannerPath = NSURL(string: (user?.profileBannerUrl)!)
            TwitterClient.sharedInstance.safeSetImageWithURL(bannerImageView, imagePath: bannerPath)
            let profilePath = NSURL(string: (user?.profileImageUrl)!)
            TwitterClient.sharedInstance.safeSetImageWithURL(profileImageView, imagePath: profilePath)
            nameLabel.text = user?.name
            screenNameLabel.text = user?.screenName
            taglineLabel.text = user?.tagline
            followingCountLabel.text = user?.followingCountString
            followerCountLabel.text = user?.followerCountString
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    

}
