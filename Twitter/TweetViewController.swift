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

        //Have to return cell each time because typing isn't very dynamic
        switch (indexPath.row) {
        case 0: //Tweet content cell
            let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell") as! ContentTableViewCell
            cell.tweet = tweet
            return cell
        case 1: //Tweet stat cell
            let cell = tableView.dequeueReusableCellWithIdentifier("StatCell") as! StatTableViewCell
            cell.tweet = tweet
            return cell
        case 2: //Tweet action cell
            let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as! ActionTableViewCell
            return cell
            //Set tweet, maybe
        default:
            let cell = UITableViewCell()
            return cell
        }
        
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
