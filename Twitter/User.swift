//
//  User.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class User: NSObject {
    var dictionary: NSDictionary
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    // ....etc....
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
}
