//
//  ActionTableViewCell.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/18/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet? {
        didSet {
            // configure selection states
            retweetButton.selected = (tweet?.retweeted)!
            likeButton.selected = (tweet?.liked)!
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
