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
    
    var tweet : Tweet? {
        didSet {
            print("this is happening \(tweet)")
            nameLabel.text = tweet?.user?.name!
            screenNameLabel.text = "@" + (tweet?.user?.screenName!)!
            contentLabel.text = tweet?.text
            createdAtLabel.text = tweet?.createdAtString
            
            // set image of user's profile picture
            let imagePath = NSURL(string: (tweet?.user?.profileImageUrl)!)
            safeSetImageWithURL(profileImageView, imagePath: imagePath)
            
            retweetLabel.text = tweet?.retweetCountString!
            likeLabel.text = tweet?.likeCountString!
        }
    }
    
    // retweet, reply, like functionality
    @IBAction func replyPressed(sender: AnyObject) {

    }
    
    @IBAction func retweetPressed(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet((tweet?.id)!, completion: {(retweetCount: String) -> Void in
            self.retweetLabel.text = retweetCount
        })
    }
    
    @IBAction func likePressed(sender: AnyObject) {
        TwitterClient.sharedInstance.like((tweet?.id)!, completion: {(likeCount: String) -> Void in
            self.likeLabel.text = likeCount
        })
    }
    
    // consider moving this to a different file...views should be the dumbest
    func safeSetImageWithURL(imageView: UIImageView, imagePath: NSURL?) {
        if imagePath != nil {
            imageView.setImageWithURLRequest(NSURLRequest(URL: imagePath!), placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    imageView.alpha = 0
                    imageView.image = image
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        imageView.alpha = 1
                    })
                }
                else {
                    imageView.image = image
                }
                }, failure: { (imageRequest, imageResponse, imageError) -> Void in
            })
        }
        else {
            // set placeholder
        }
    }

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
