//
//  ContentTableViewCell.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/18/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var createdAtDetailLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            let imagePath = NSURL(string: (tweet?.user?.profileImageUrl)!)
            TwitterClient.sharedInstance.safeSetImageWithURL(profileImageView, imagePath: imagePath)
            nameLabel.text = tweet?.user?.name
            screenNameLabel.text = tweet?.user?.screenName
            contentLabel.text = tweet?.text
            createdAtDetailLabel.text = tweet?.createdAtDetailString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
