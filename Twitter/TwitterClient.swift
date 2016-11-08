//
//  TwitterClient.swift
//  
//
//  Created by Zhia Chong on 10/28/16.
//
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "VcG9CAB1fWaBnFcsr8aGZqVz1"
let twitterConsumerSecret = "8en2FCggUNqIfuOZIdc8UVghoU9OQc35pjIRIIGKq4petDMR0U"
let twitterBaseUrl = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((_ user: User?, _ error: Error?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance!
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()) {
        TwitterClient.sharedInstance.get("1.1/statuses/home_timeline.json", parameters: params, progress: { (progress) in
            print (progress)
            }, success: { (session, results) in
                let tweets = Tweet.tweetsWithArray(array: results as! [NSDictionary])
               
                completion(tweets, nil)
            }, failure: { (session, error) in
                print("session \(session)")
                print (error)
                completion(nil, error)
        })
    }
    
    func postTweet(params: NSDictionary?, completion: @escaping (_ response: Bool?, _ error: Error?) -> ()) {
        TwitterClient.sharedInstance.post("1.1/statuses/update.json", parameters: params, progress: { (progress) in
            print (progress)
            }, success: { (session, response) in
                completion(true, nil)
            }, failure: { (session, error) in
                print ("session failed: \(error)")
                completion(nil, error)
        })
    }
    
    func loginWithCompletion(completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"cptwitterdemo://auth"), scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            print ("Successfully retrieved the token!")
            let token = requestToken?.token
            let authUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")
            UIApplication.shared.openURL(authUrl!)
            
            }, failure: {(error: Error?) -> Void in
                print ("Failed to get the tokeN!")
                self.loginCompletion?(nil, error)
            }
        )
    }
    
    func openUrl(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) in
            print("Got my access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress) in
                print (progress)
                }, success: { (session, results) in
                    let user = User(dictionary: results as! NSDictionary)
                    User.currentUser = user
                    print("user: \(user.name)")
                    self.loginCompletion?(user, nil)
                }, failure: { (session, error) in
                    print (error)
                    self.loginCompletion?(nil, error)
            })
            
            
        }) { (error: Error?) in
            print ("Shoot!\(error)" )
        }
    }
    
    func getUser(screenName: String, count: Int = 20, success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: users/show.json")
        
        let params = ["screen_name" : screenName]                      
        
        TwitterClient.sharedInstance.get("1.1/users/show.json", parameters: params, progress: nil, success: { (task, response: Any?) in
            
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure(error)
        })
    }
    
    func userTimeline(screenName: String, count: Int = 20, success: @escaping ([Tweet]) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: statuses/user_timeline")

        let params = ["screen_name" : screenName,
                      "count" : count,
                      "include_rts": true] as [String : Any]

        TwitterClient.sharedInstance.get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task, response: Any?) in

            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])

            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error?) in
                failure(error)
        })
    }
    
    func mentionsTimeline(screenName: String, count: Int = 20, success: @escaping ([Tweet]) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: statuses/mentions_timeline")
        
        let params = ["screen_name" : screenName,
                      "count" : count,
                      "include_rts": true] as [String : Any]
        
        TwitterClient.sharedInstance.get("1.1/statuses/mentions_timeline.json", parameters: params, progress: nil, success: { (task, response: Any?) in
            
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure(error)
        })
    }
    
    func mentionsTimelineWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()) {
        print("TwitterClient: statuses/mentions_timeline")
        
        TwitterClient.sharedInstance.get("1.1/statuses/mentions_timeline.json", parameters: params, progress: nil, success: { (task, response: Any?) in
            
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            
            completion(tweets, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            print ("Error! ")
        })
    }

}
