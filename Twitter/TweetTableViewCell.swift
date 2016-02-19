//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    
    var tweet : Tweet? {
        didSet {
            nameLabel.text = tweet?.user?.name!
            screenNameLabel.text = "@" + (tweet?.user?.screenName)!
            contentLabel.text = tweet?.text
            createdAtLabel.text = tweet?.timeSinceCreatedString
            
            // set image of user's profile picture
            let imagePath = NSURL(string: (tweet?.user?.profileImageUrl)!)
            TwitterClient.sharedInstance.safeSetImageWithURL(profileImageView, imagePath: imagePath)
            
            retweetLabel.text = tweet?.retweetCountString!
            likeLabel.text = tweet?.likeCountString!
            
            retweetLabel.textColor = tweet?.retweetLabelColor
            likeLabel.textColor = tweet?.likeLabelColor
            
            // configure selection states
            retweetButton.selected = (tweet?.retweeted)!
            likeButton.selected = (tweet?.liked)!
            
        }
    }
    
    // consider moving this to a different file...views should be the dumbest


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.sizeToFit()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
