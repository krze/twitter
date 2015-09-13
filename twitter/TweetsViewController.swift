//
//  TweetsViewController.swift
//  twitter
//
//  Created by iKreb Retina on 9/12/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweetButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // These two properties must be set in order to use auto layout and ensure the scroll bar appears at a sane size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
        refresh(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRefreshControl() {
        // Pull to Refresh
        self.refreshControl = UIRefreshControl()
        //        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size:12)!])
//        self.refreshControl.tintColor = UIColor.orangeColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func refresh(sender:AnyObject) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl?.endRefreshing()
    }
    
    func newTweet() {
            self.performSegueWithIdentifier("createNewTweetSegue", sender: self)
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            println("Got tweets!")
            return tweets.count
        } else {
            println("Got nothing!")
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
            
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        
        // Debugging
        println(cell.tweet)
        
        self.performSegueWithIdentifier("tweetDetailViewSegue", sender: cell)
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onNewTweet(sender: AnyObject) {
        newTweet()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailViewSegue") {
            var detailViewController = segue.destinationViewController as! TweetDetailViewController
            var cell = sender as! UITableViewCell
            var indexPath = tableView.indexPathForCell(cell)!
            var tweet = tweets[indexPath.row]
            
            detailViewController.tweet = tweet
        }
    }

}
