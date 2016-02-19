//
//  Tweet.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    // UIColor from brand guideline hex codes
    let retweetedColor = UIColor(red: 0.09803921568, green: 0.81176470588, blue: 0.52549019607, alpha: 1)
    let likedColor = UIColor(red: 0.90980392156, green: 0.10980392156, blue: 0.30980392156, alpha: 1)
    
    var user: User?
    var text: String?
    var createdAtDetailString: String? // 2/17/16, 2:15 PM
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: NSNumber?
    var retweetCountString: String?
    var likeCount: NSNumber?
    var likeCountString: String?
    var id: String?
    var retweeted: Bool?
    var liked: Bool?
    var timeSinceCreatedString: String?
    var retweetLabelColor: UIColor!
    var likeLabelColor: UIColor!
    var retweetedStatus: NSDictionary?
    var currentUserRetweet: NSDictionary?
    
    
    init(dictionary: NSDictionary) {
        super.init()
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        user = User(dictionary: dictionary["user"] as! NSDictionary )
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? NSNumber
        retweetCountString = Tweet.format(retweetCount!)
        
        // must use retweeted_status to get favorite count if the tweet is a RT
        likeCount = retweetedStatus != nil ? retweetedStatus!["favorite_count"] as? NSNumber : dictionary["favorite_count"] as? NSNumber
        likeCountString = Tweet.format(likeCount!)
        id = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        liked = dictionary["favorited"] as? Bool
        
        currentUserRetweet = dictionary["current_user_retweet"] as? NSDictionary
        
        // label colors are determined in the tweet data structure
        // to minimize the amount of code in the views
        // (please let me know if this is not within best practices)
        retweetLabelColor = retweeted! ? retweetedColor : UIColor.lightGrayColor()
        likeLabelColor = liked! ? likedColor : UIColor.lightGrayColor()
        // selection state is the same as retweeted or liked value
        
        let formatter = NSDateFormatter() // expensive; usually want a static formatter
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        timeSinceCreatedString = convertTimeToString(Int(NSDate().timeIntervalSinceDate(createdAt!)))
        formatter.dateFormat = "MMM d"
        createdAtString = formatter.stringFromDate(createdAt!)
        formatter.dateFormat = "M/D/yy, H:mm a"
        createdAtDetailString = formatter.stringFromDate(createdAt!).uppercaseString
    }
    
    // format an array of tweets from the response dictionary
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
    
    // change stats >= 1000 to have K abbreviation
    class func format(stat: NSNumber) -> String{
        return stat.doubleValue >= 1000000 ? String(format: "%.1fM", arguments: [stat.doubleValue/1000000]) :
            stat.doubleValue >= 1000 ? String(format: "%.1fK", arguments: [stat.doubleValue/1000]) : "\(stat.integerValue)"
    }
    
    // make timestamp friendlier
    func convertTimeToString(number: Int) -> String {
        let day = number/86400
        let hour = (number - day * 86400)/3600
        let minute = (number - day * 86400 - hour * 3600)/60
        if day != 0 {
            return String(day) + "d"
        } else if hour != 0 {
            return String(hour) + "h"
        } else {
            return String(minute) + "m"
        }
    }
}

