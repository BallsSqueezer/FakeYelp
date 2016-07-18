//
//  QuickInfoCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var phoneLabel: UILabel!
    
    var business: Business! {
        didSet {
            if let address = business.address {
                addressLabel.text = address
            } else {
                addressLabel.text = "Not Available"
            }
            
            phoneLabel.text = business.displayPhone
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
