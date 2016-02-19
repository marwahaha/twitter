//
//  TweetViewController.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/17/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var tweet: Tweet!
    
    var contentCell: ContentTableViewCell!
    
    var statCell: StatTableViewCell!
    
    var actionCell: ActionTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print(tweet.createdAtDetailString)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView(frame: CGRectZero)

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Have to return cell each time because typing isn't very dynamic
        switch (indexPath.row) {
        case 0: //Tweet content cell
            let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell") as! ContentTableViewCell
            cell.tweet = tweet
            contentCell = cell
            return cell
        case 1: // Tweet stat cell
            let cell = tableView.dequeueReusableCellWithIdentifier("StatCell") as! StatTableViewCell
            cell.tweet = tweet
            statCell = cell
            return cell
        case 2: // Tweet action cell
            let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as! ActionTableViewCell
            // Add actions for buttons
            // cell.replyButton.addTarget(self, action: "replyPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.tweet = tweet
            cell.retweetButton.addTarget(self, action: "retweetPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.likeButton.addTarget(self, action: "likePressed:", forControlEvents: UIControlEvents.TouchUpInside)
            actionCell = cell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    // handle retweet pressed
    func retweetPressed(sender: UIButton!) {
        // if selected, unretweet
        if sender.selected {
            // unretweet, update numbers/colors/selected state on success
            TwitterClient.sharedInstance.unretweet(tweet.id!, params: nil, completion: { (retweetCount) -> () in
                self.tweet.retweeted = false
                self.tweet.retweetCount = retweetCount // set to response value
                self.tweet.retweetCountString = Tweet.format(self.tweet.retweetCount!)
                self.statCell.retweetLabel.text = self.tweet.retweetCountString
                // I don't think the color should be updated here
            })
        }
            // else, retweet
        else {
            // retweet, update numbers/colors/selected state on sucesss
            TwitterClient.sharedInstance.retweet(tweet.id!, params: nil, completion: { (retweetCount) -> () in
                self.tweet.retweeted = true
                self.tweet.retweetCount = retweetCount
                self.tweet.retweetCountString = Tweet.format(self.tweet.retweetCount!)
                self.statCell.retweetLabel.text = self.tweet.retweetCountString 
            })
        }
        sender.selected = !sender.selected
    }
    
    // handle like button pressed
    func likePressed(sender: UIButton) {
        // if selected, unlike
        if sender.selected {
            // unretweet, update numbers/colors/selected state on success
            TwitterClient.sharedInstance.unlike(tweet.id!, params: nil, completion: { (likeCount) -> () in
                self.tweet.liked = false
                self.tweet.likeCount = NSNumber(integer: self.tweet.likeCount!.integerValue - 1)
                self.tweet.likeCountString = Tweet.format(self.tweet.likeCount!)
                self.statCell.likeLabel.text = self.tweet.likeCountString
            })
        }
            // else, like
        else {
            // retweet, update numbers/colors/selected state on sucesss
            TwitterClient.sharedInstance.like(tweet.id!, params: nil, completion: { (likeCount) -> () in
                self.tweet.liked = true
                self.tweet.likeCount = NSNumber(integer: self.tweet.likeCount!.integerValue + 1)
                self.tweet.likeCountString = Tweet.format(self.tweet.likeCount!)
                self.statCell.likeLabel.text = self.tweet.likeCountString
            })
        }
        sender.selected = !sender.selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
