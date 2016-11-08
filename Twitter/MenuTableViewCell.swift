//
//  MenuTableViewCell.swift
//  Twitter
//
//  Created by Zhia Chong on 11/7/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import SwiftIconFont

class MenuTableViewCell: UITableViewCell {
    let ICON_LABEL_KEY = "icon_label"
    let DESCRIPTION_KEY = "description"
    
    var iconLabelText: String! {
        didSet {
            print ("Icon: \(iconLabelText)")
            
            iconLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 30.0)
            iconLabel.text = String.fontAwesomeIcon(iconLabelText)
        }
    }
    
    var descriptionLabelText: String! {
        didSet {
            print ("Description is set! \(descriptionLabelText)")
            descriptionLabel.text = descriptionLabelText as String!
        }
    }
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
