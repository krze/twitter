//
//  TweetCell.swift
//  twitter
//
//  Created by iKreb Retina on 9/12/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func replyTo(cell: UITableViewCell)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    
    var delegate: TweetCellDelegate?

    var tweet: Tweet! {
        didSet {
            var url = NSURL(string: tweet.user!.profileImageUrl!)
            println(url)
            usernameLabel.text = "@\(tweet.user?.screenname as String!)"
            avatarImage.setImageWithURL(url)
            displayNameLabel.text = tweet.user?.name
            tweetBodyLabel.text = tweet.text
            timeAgoLabel.text = tweet.timeSinceString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var reply = UITapGestureRecognizer(target: self, action: Selector("reply"))
        var fav = UITapGestureRecognizer(target: self, action: Selector("fav"))
        var retweet = UITapGestureRecognizer(target: self, action: Selector("retweet"))
        
        replyImage.image = UIImage(named: "reply_icon")
        replyImage.addGestureRecognizer(reply)
        favImage.image = UIImage(named: "fav_icon")
        favImage.addGestureRecognizer(fav)
        retweetImage.image = UIImage(named: "retweet_icon")
        retweetImage.addGestureRecognizer(retweet)
        
        tweetBodyLabel.preferredMaxLayoutWidth = tweetBodyLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetBodyLabel.preferredMaxLayoutWidth = tweetBodyLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reply() {
        if let delegate = self.delegate {
            delegate.replyTo!(self)
        }

    }
    
    func fav() {
        var id = tweet.id as String!
        
        TwitterClient.sharedInstance.favTweet(["id": id], completion: { (error) -> () in
            if error != nil {
                println(error)
            } else {
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    
    func retweet() {
        var id = tweet.id as String!
        
        TwitterClient.sharedInstance.retweetTweet(id, params: nil, completion: { (error) -> () in
            if error != nil {
                println(error)
            } else {
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }

}
