//
//  TweetsViewController.swift
//  twitter
//
//  Created by iKreb Retina on 9/12/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, TweetCellDelegate {
    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweetButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    
    var repliedFromTimeline = false
    
    @IBOutlet weak var timelineView: UIView!
    
    var timelineOriginalCenter: CGPoint!
    var timelineContracted: CGPoint!
    var timelineExpanded: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        println("Center on load is: \(timelineView.center)")
        timelineExpanded = CGPoint(x: 160.0, y: 284.0)
        timelineContracted = CGPoint(x: 368.0, y: 284.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // These two properties must be set in order to use auto layout and ensure the scroll bar appears at a sane size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
//        refresh(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
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
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        println("Attempting to tap on cell")

        tappedOnCell(cell, tappedReply: false)
    }
    
    
    func tappedOnCell(cell: UITableViewCell, tappedReply: Bool){
        let cell = cell
        repliedFromTimeline = tappedReply
        self.performSegueWithIdentifier("tweetDetailViewSegue", sender: cell)
        println("Tapped on cell")
    }
    
    func animateExpandTimeline() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: nil, animations: { () -> Void in
            self.timelineView.center = self.timelineExpanded
        }) { (Bool) -> Void in
            println("It done")
        }
        
        
    }
    
    func animateContractTimeline() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: nil, animations: { () -> Void in
            self.timelineView.center = self.timelineContracted
            }) { (Bool) -> Void in
                println("It done")
        }
        
    }
    
    
    func replyTo(cell: UITableViewCell) {
        tappedOnCell(cell, tappedReply: true)
    }
    
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onNewTweet(sender: AnyObject) {
        newTweet()
    }

    
    @IBAction func onPanView(sender: UIPanGestureRecognizer) {
        var panGestureRecognizer = sender
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        var contracting = Bool()
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            timelineOriginalCenter = timelineView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            timelineView.center = CGPoint(x: timelineOriginalCenter.x + translation.x, y: timelineOriginalCenter.y)
            println("Current Tray Center Is: \(timelineView.center)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            
            if velocity.x > 0 {
                contracting = true
            } else {
                contracting = false
            }
            if contracting {
                animateContractTimeline()
            } else {
                animateExpandTimeline()
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailViewSegue") {
            var detailViewController = segue.destinationViewController as! TweetDetailViewController
            var cell = sender as! UITableViewCell
            var indexPath = tableView.indexPathForCell(cell)!
            var tweet = tweets[indexPath.row]
            
            detailViewController.tweet = tweet
            detailViewController.replyOnLoad = repliedFromTimeline
        }
    }

}
