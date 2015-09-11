//
//  TwitterClient.swift
//  twitter
//
//  Created by iKreb Retina on 9/10/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

let twitterConsumerKey = "UiRfwjpiJ103xCtvIPD2x9XrI"
let twitterConsumerSecret = "JCQp6qLxPftBmbcvYNSRpMqkJvUG9Z13nghkbkZLeh4p1MBF51"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}
