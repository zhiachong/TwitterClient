//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Zhia Chong on 11/7/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import ALLoadingView
import SwiftIconFont

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate {
    var tweets: [Tweet]?
    var isMoreDataLoading: Bool! = false
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var composeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        composeBarButtonItem.icon(from: .FontAwesome, code: "edit", ofSize: 20.0)
        logoutBarButtonItem.icon(from: .FontAwesome, code: "sign-out", ofSize: 20.0)
        // Do any additional setup after loading the view.
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        ALLoadingView.manager.blurredBackground = true
        TwitterClient.sharedInstance.mentionsTimeline(screenName: (User.currentUser?.screenName)!, success: { (tweets) in
                print("I got ma tweets bitch!")
            
                self.tweets = tweets
                ALLoadingView.manager.hideLoadingView()
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error!)
                ALLoadingView.manager.hideLoadingView()
            })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                loadMoreDataWithNewData(true, nil)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func composeTapped(_ sender: AnyObject) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
    }
    
    func setupView() {
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0, green: 0.67, blue: 0.929, alpha: 1.0)
        
        // setup refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        if (!isMoreDataLoading) {
            isMoreDataLoading = true
            loadMoreDataWithNewData(false, nil)
        }
        
        refreshControl.endRefreshing()
    }
    
    func loadMoreDataWithNewData(_ loadNewData: Bool, _ params: NSDictionary?) {
        let lastTweet = self.tweets?[(self.tweets?.count)! - 1] ?? nil
        var maxId = ""
        let params = NSMutableDictionary()
        if (lastTweet != nil && loadNewData == true) {
            maxId = (lastTweet?.id)!
            params.setValue(maxId, forKey: "max_id")
        }
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        ALLoadingView.manager.blurredBackground = false
        TwitterClient.sharedInstance.mentionsTimelineWithParams(params: params, completion: {(tweets, error) in
            let last = tweets?[(tweets?.count)! - 1] ?? nil
            if (last != nil) {
                let max = last?.id
                if (max == maxId) {
                    self.isMoreDataLoading = true
                    ALLoadingView.manager.hideLoadingView()
                    return
                }
            }
            if (loadNewData) {
                self.tweets?.append(contentsOf: tweets as [Tweet]!)
            } else {
                self.tweets = tweets
            }
            
            ALLoadingView.manager.hideLoadingView()
            self.tableView.reloadData()
            self.isMoreDataLoading = false
        })
        
    }
    
    func composeViewController(composeViewController: ComposeViewController, didSendText text: String) {
        
        let params = NSMutableDictionary()
        params.setValue(text, forKey: "status")
        
        TwitterClient.sharedInstance.postTweet(params: params) { (success, error) in
            if (error == nil) {
                self.loadMoreDataWithNewData(false, nil)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destination as! UINavigationController
        let composeViewController = navigationController.topViewController as! ComposeViewController
        composeViewController.delegate = self
    }

}
