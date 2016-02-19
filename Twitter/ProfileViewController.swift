//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kyle Wilson on 2/10/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User?
    
    var tweets: [Tweet]?
    
    var isMoreDataLoading = false
    
    var tweetAccumulator = 20
    
    var loadingMoreView: InfiniteScrollActivityView?
    
    @IBOutlet weak var profileInfoView: ProfileInfoView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var infoView: UIView!
    
    // this tableView can basically be the tweets tableView
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        if user == nil {
            user = User.currentUser
        }
        
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        profileInfoView.user = user
        tableView.dataSource = self
        tableView.delegate = self
        // Necessary for cell resizing to show all content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Set up Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // only real difference between the tables
        TwitterClient.sharedInstance.userTimelineWithParams((user?.id)!, params: nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets != nil ? (tweets?.count)! : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        // add event handling for profile select, retweet, and like events
        let singleTap = UITapGestureRecognizer(target: self, action: "segueToProfile:")
        singleTap.numberOfTapsRequired = 1
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.userInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(singleTap)
        cell.retweetButton.tag = indexPath.row
        cell.retweetButton.addTarget(self, action: "retweetPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: "likePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.userTimelineWithParams((user?.id)!, params: ["count": tweetAccumulator],completion: {
            (tweets,error) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        });
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    // load 20 more tweets after scrolling is finished
    func loadMoreData() {
        tweetAccumulator += 20
        TwitterClient.sharedInstance.userTimelineWithParams((user?.id)!, params: ["count": tweetAccumulator],completion: {
            (tweets,error) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.loadingMoreView!.stopAnimating()
            self.isMoreDataLoading = false
        });
        
    }
    
    
    // handle profile image tapped
    func segueToProfile(sender: UITapGestureRecognizer!) {
        print("here")
        print("no crash, sender's tag is \(sender.view!.tag)")
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.view!.tag, inSection: 0)) as! TweetTableViewCell
        let user = cell.tweet?.user
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.user = user
        self.navigationController!.pushViewController(profileViewController, animated:true)
        
    }
    
    // handle retweet pressed
    func retweetPressed(sender: UIButton!) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! TweetTableViewCell
        let tweet = cell.tweet!
        // if selected, unretweet
        if sender.selected {
            // something aint right
            // unretweet, update numbers/colors/selected state on success
            TwitterClient.sharedInstance.unretweet(tweet.id!, params: nil, completion: { (retweetCount) -> () in
                tweet.retweeted = false
                tweet.retweetCount = retweetCount // set to response value
                // cell.tweet!.id = id
                tweet.retweetCountString = Tweet.format(tweet.retweetCount!)
                cell.retweetLabel.text = tweet.retweetCountString
                cell.retweetLabel.textColor = UIColor.lightGrayColor()
            })
        }
            // else, retweet
        else {
            // retweet, update numbers/colors/selected state on sucesss
            TwitterClient.sharedInstance.retweet(tweet.id!, params: nil, completion: { (retweetCount) -> () in
                tweet.retweeted = true
                tweet.retweetCount = retweetCount
                // cell.tweet!.id = id // maybe this will help
                tweet.retweetCountString = Tweet.format(tweet.retweetCount!)
                cell.retweetLabel.text = tweet.retweetCountString
                cell.retweetLabel.textColor = tweet.retweetedColor
            })
        }
        sender.selected = !sender.selected
    }
    
    // handle like button pressed
    func likePressed(sender: UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! TweetTableViewCell
        let tweet = cell.tweet!
        // if selected, unlike
        if sender.selected {
            // unretweet, update numbers/colors/selected state on success
            TwitterClient.sharedInstance.unlike(tweet.id!, params: nil, completion: { (likeCount) -> () in
                tweet.liked = false
                tweet.likeCount = NSNumber(integer: tweet.likeCount!.integerValue - 1)
                tweet.likeCountString = Tweet.format(tweet.likeCount!)
                cell.likeLabel.text = tweet.likeCountString
                cell.likeLabel.textColor = UIColor.lightGrayColor()
            })
        }
            // else, like
        else {
            // retweet, update numbers/colors/selected state on sucesss
            TwitterClient.sharedInstance.like(tweet.id!, params: nil, completion: { (likeCount) -> () in
                tweet.liked = true
                tweet.likeCount = NSNumber(integer: tweet.likeCount!.integerValue + 1)
                tweet.likeCountString = Tweet.format(tweet.likeCount!)
                cell.likeLabel.text = tweet.likeCountString
                cell.likeLabel.textColor = tweet.likedColor
            })
        }
        sender.selected = !sender.selected
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailSegue" {
            let vc = segue.destinationViewController as! TweetViewController
            let tweet = tweets![(tableView.indexPathForCell(sender as! UITableViewCell)?.row)!]
            vc.tweet = tweet
        }
        
    }
    
    // control logout capability based on user
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if user?.id != User.currentUser?.id {
            logoutButton.alpha = 0
        }
        else {
            logoutButton.alpha = 1
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
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
