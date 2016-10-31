//
//  User.swift
//  Twitter
//
//  Created by Zhia Chong on 10/29/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit


var _currentUser: User?
let currentUserKey = "kCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var followersCount: Int?
    var friendsCount: Int?
    var statusesCount: Int?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                        _currentUser = User(dictionary:  dictionary as! NSDictionary)
                    } catch {
                        print ("Error while deserializing the object!" )
                    }
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user!.dictionary!, options: .prettyPrinted)
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                } catch {
                    print ("Error while trying to serialize!")
                }
                
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}
