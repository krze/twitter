//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by iKreb Retina on 9/13/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    
    @IBOutlet weak var replyView: UIView!
    
    @IBOutlet weak var replyTextView: UITextView!
    
    var tweet: Tweet!
    var replyOnLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Got tweet from timeline: \(tweet)")
        
        var reply = UITapGestureRecognizer(target: self, action: Selector("reply"))
        var fav = UITapGestureRecognizer(target: self, action: Selector("fav"))
        var retweet = UITapGestureRecognizer(target: self, action: Selector("retweet"))
    
        replyImage.image = UIImage(named: "reply_icon")
        replyImage.addGestureRecognizer(reply)
        favImage.image = UIImage(named: "fav_icon")
        favImage.addGestureRecognizer(fav)
        retweetImage.image = UIImage(named: "retweet_icon")
        retweetImage.addGestureRecognizer(retweet)
        
        loadTweet()
        tweetBodyLabel.preferredMaxLayoutWidth = tweetBodyLabel.frame.size.width
        
        if replyOnLoad {
            self.reply()
        } else {
            replyView.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        tweetBodyLabel.preferredMaxLayoutWidth = tweetBodyLabel.frame.size.width
//    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reply() {
        var recipient = "@\(tweet.user?.screenname as String!) "
        replyView.hidden = false
        replyTextView.text = recipient
        replyTextView.becomeFirstResponder()
    }
    
    func fav() {
        var id = tweet.id as String!
        
        TwitterClient.sharedInstance.favTweet(["id": id], completion: { (error) -> () in
            if error != nil {
                println(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    
    func retweet() {
        var id = tweet.id as String!
   
        TwitterClient.sharedInstance.retweetTweet(id, params: nil, completion: { (error) -> () in
            if error != nil {
                println(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        replyTextView.text = ""
        replyView.hidden = true
        replyTextView.resignFirstResponder()
    }
    
    @IBAction func onReply(sender: AnyObject) {
        var id = tweet.id as String!
        
        TwitterClient.sharedInstance.createNewTweet(["status": replyTextView.text, "in_reply_to_status_id": id], completion: { (tweet, error) -> () in
            if tweet != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                println("Replied to \(id)")
            }
            if error != nil {
                println("error")
            }
        })
    }
    
    
    func loadTweet() {
        var url = NSURL(string: tweet.user!.profileImageUrl!)
        usernameLabel.text = "@\(tweet.user?.screenname as String!)"
        avatarImage.setImageWithURL(url)
        displayNameLabel.text = tweet.user?.name
        tweetBodyLabel.text = tweet.text
        timeAgoLabel.text = tweet.timeSinceString
    }
}
