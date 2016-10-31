//
//  Tweet.swift
//  Twitter
//
//  Created by Zhia Chong on 10/29/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAtDate: NSDate?
    var id: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss xxxx yyyy"
        let date = dateFormatter.date(from: createdAtString!)
        createdAtDate = date as NSDate?
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for i in array {
            tweets.append(Tweet(dictionary: i))
        }
        
        return tweets
    }
}
