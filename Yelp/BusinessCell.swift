//
//  BusinessCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var reviewImageView: UIImageView!
    
    var business: Business! {
        didSet {
            if business.imageURL != nil {
                restaurantImageView.alpha = 0.0
                UIView.animateWithDuration(0.3, animations: { _ in
                    self.restaurantImageView.setImageWithURL(self.business.imageURL!)
                    self.restaurantImageView.alpha = 1.0
                })
            } else {
                restaurantImageView.image = UIImage(named: "noImage")
            }
            nameLabel.text = business.name
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            distanceLabel.text = business.distance
            if let reviewCount = business.reviewCount {
                reviewCountLabel.text = "\(reviewCount) reviews"
            }
            if business.ratingImageURL != nil {
                reviewImageView.setImageWithURL(business.ratingImageURL!)
            } else{
                reviewImageView.image = UIImage(named: "noImage")
            }
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
