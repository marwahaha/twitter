//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/9/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "uEGBWYu73NSjORz9W7Dnc2KVE"
let twitterConsumerSecret = "P8Mo6GO5cXYb2SVMTXUmsobXUFqMCDAA1R4KrPlfmnPyOQbpVp"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}
