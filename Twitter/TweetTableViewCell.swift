//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Zhia Chong on 10/31/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetTableViewCellDelegate {
    @objc optional func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didTapOnUser userName: String)
}

class TweetTableViewCell: UITableViewCell {
    weak var delegate: TweetTableViewCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            if (tweet.user?.profileImageUrl != nil) {
                profileHeaderImageView.setImageWith(URL(string: (tweet.user?.profileImageUrl)!)!)
            }
            
            if (tweet.user?.name != nil) {
                nameLabel.text = tweet.user?.name
            }
            
            if (tweet.user?.screenName != nil) {
                screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            }
            
            if (tweet.createdAtDate != nil) {
                let dateFormatter = DateFormatter()
                let dateString = dateFormatter.timeSince(from: tweet.createdAtDate!, numericDates: true)
                createAtLabel.text = dateString
            }
            
            if (tweet.text != nil) {
                tweetLabel.text = tweet.text
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(faceTapped))
            tapGestureRecognizer.numberOfTapsRequired = 1
            profileHeaderImageView.isUserInteractionEnabled = true
            profileHeaderImageView.addGestureRecognizer(tapGestureRecognizer)
            print ("Set up the tap gesture") 
        }
    }

    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileHeaderImageView.layer.cornerRadius = 45
        profileHeaderImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func faceTapped() {
        print("face tapped \((tweet.user?.name)!)")
        delegate?.tweetTableViewCell!(tweetTableViewCell: self, didTapOnUser: (tweet.user?.screenName)!)
    }
}
