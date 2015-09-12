//
//  TweetCell.swift
//  twitter
//
//  Created by iKreb Retina on 9/12/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
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

}
