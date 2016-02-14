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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        // getting timeline data
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("There was an error getting the home timeline: \(error.description)")
                completion(tweets: nil, error: error)
        })
    
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken() // returns the user to a logged-out state, which is assumed in the following steps
        // Step 1: Get Request Token
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestCredential: BDBOAuth1Credential!) -> Void in
            // Step 2: Build Authorization Page URL with Token
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestCredential.token!)")!
            // (Outside of this code) Set up app to handle the callbackURL from the token request
            // This is where Twitter will redirect you after the authorization is complete (we want to go back to our app)
            UIApplication.sharedApplication().openURL(authURL)
        }) { (error: NSError!) -> Void in
            print("There was an error getting the request credentials: \(error.description)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        // Step 3: Get the access token
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            // initial endpoint hit
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("There was an error getting the user: \(error.description)")
                self.loginCompletion?(user: nil, error: error)
            })
            

            
            }) { (error: NSError!) -> Void in
                print("There was an error getting the access token: \(error.description)")
        }

    }
    
    func retweet(id: String, params: NSDictionary?, completion: (retweetCount: NSNumber) -> ()) {
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let retweetCount = (response as! NSDictionary)["retweet_count"] as! NSNumber
                completion(retweetCount: retweetCount)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to retweet tweet with id \(id)")
        }
    }
    
    func unretweet(id: String, params: NSDictionary?, completion: (retweetCount: NSNumber) -> ()) {
            TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            var retweetCount = (response as! NSDictionary)["retweet_count"] as! NSNumber
            // takes a refresh to update, so manually decrement here (not exact)
            retweetCount = NSNumber(integer: retweetCount.integerValue - 1)
            completion(retweetCount: retweetCount)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to unretweet tweet with id \(id)")
        }
    }
    
    func like(id: String, params: NSDictionary?, completion: (likeCount: NSNumber) -> ()) {
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dict = response as! NSDictionary
            let likeCount = dict["favorite_count"] as! NSNumber
            completion(likeCount: likeCount)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to like tweet with id \(id)")
        }
    }
    
    func unlike(id: String, params: NSDictionary?, completion: (likeCount: NSNumber) -> ()) {
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dict = response as! NSDictionary
            let likeCount = dict["favorite_count"] as! NSNumber
            completion(likeCount: likeCount)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to like tweet with id \(id)")
        }
    }
    
    func tweet(status: String, params: NSDictionary?, completion: (id: String) -> ()) {
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/statuses/update.json?status=\(status)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success")
            completion(id: (response as! NSDictionary)["id_str"] as! String)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to tweet with error code \(error.description)")
        }
    }

}
