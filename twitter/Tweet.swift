//
//  Tweet.swift
//  twitter
//
//  Created by iKreb Retina on 9/12/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSinceString: String?
    var id: String?
    
    class func tweetTimeStampAsString(timestamp: NSDate) -> String {
        var ti = -Int(timestamp.timeIntervalSinceNow)
        var timeAsString: String?
        
        if ti < 60 {
            timeAsString = "\(ti)s"
        } else if ti < 3600 {
            var mins = ti / 60
            timeAsString = "\(mins)m"
        } else if ti < 86400 {
            var hours = (ti / 60) / 60
            timeAsString = "\(hours)h"
        } else {
            var days = ((ti / 60) / 60) / 24
            timeAsString = "\(days)d"
        }
        return timeAsString!
    }

    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
        
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        timeSinceString = Tweet.tweetTimeStampAsString(createdAt!)
        println("Tweet was Created At: \(createdAt!)")
        println("Tweet was created \(Tweet.tweetTimeStampAsString(createdAt!)) ago")
    }
    

    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
