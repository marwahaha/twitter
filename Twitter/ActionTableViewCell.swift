//
//  ActionTableViewCell.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/18/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            
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
