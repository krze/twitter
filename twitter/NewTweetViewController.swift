//
//  NewTweetViewController.swift
//  twitter
//
//  Created by iKreb Retina on 9/13/15.
//  Copyright (c) 2015 krze. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    
    @IBOutlet weak var newTweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCreate(sender: AnyObject) {
        TwitterClient.sharedInstance.createNewTweet(["status": newTweetTextView.text], completion: { (tweet, error) -> () in
            if tweet != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if error != nil {
                println("error")
            }
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
