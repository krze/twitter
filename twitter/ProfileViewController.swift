//
//  ProfileViewController.swift
//  twitter
//
//  Created by iKreb Retina on 9/16/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate  {
    var tweets: [Tweet]!
    var repliedFromTimeline = false
    var user: User?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // These two properties must be set in order to use auto layout and ensure the scroll bar appears at a sane size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refresh(self)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.performSegueWithIdentifier("tweetDetailViewFromProfileSegue", sender: cell)
        println("Tapped on cell")
    }
    
    
    func replyTo(cell: UITableViewCell) {
        tappedOnCell(cell, tappedReply: true)
    }
    
    func viewProfileId(id: String) {
        
    }
    
    func refresh(sender:AnyObject) {
        var id = user?.id as String!
        
        TwitterClient.sharedInstance.userTimelineWithParams(["user_id": id], completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
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
