//
//  User.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var dictionary: NSDictionary
    var id: String?
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileBannerUrl: String?
    var tagline: String?
    var followerCount: NSNumber?
    var followerCountString: String?
    var followingCount: NSNumber?
    var followingCountString: String?
    // ....etc....
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        print(profileImageUrl)
        profileBannerUrl = dictionary["profile_banner_url"] as? String
        tagline = dictionary["description"] as? String
        followerCount = dictionary["followers_count"] as? NSNumber
        followerCountString = Tweet.format(followerCount!)
        followingCount = dictionary["friends_count"] as? NSNumber
        followingCountString = Tweet.format(followingCount!)
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        _currentUser = User(dictionary: dict)
                    } catch {
                        print("try catch failed line 38")
                    }
        
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("try catch failed line 55")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
