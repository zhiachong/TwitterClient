//
//  ViewController.swift
//  Twitter
//
//  Created by Zhia Chong on 10/28/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion { (user: User?, error: Error?) in
            if (error == nil) {
                self.performSegue(withIdentifier: "modalSegue", sender: self)
            } else {
                print ("error happened \(error)")
            }
        }
    }


}

