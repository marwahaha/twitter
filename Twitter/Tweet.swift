//
//  Tweet.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: NSNumber?
    var retweetCountString: String?
    var likeCount: NSNumber?
    var likeCountString: String?
    var id: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary )
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? NSNumber
        retweetCountString = "\(retweetCount!)"
        likeCount = dictionary["favorite_count"] as? NSNumber
        likeCountString = "\(likeCount!)"
        id = dictionary["id_str"] as? String
        
        let formatter = NSDateFormatter() // expensive; usually want a static formatter
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "MMM d"
        createdAtString = formatter.stringFromDate(createdAt!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
}

