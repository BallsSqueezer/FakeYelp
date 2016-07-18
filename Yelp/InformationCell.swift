//
//  ImageCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class InformrationCell: UITableViewCell {
    @IBOutlet weak var restaurantImageView: UIImageView!

    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var business: Business! {
        didSet {
            if business.imageURL != nil {
                restaurantImageView.alpha = 0.0
                UIView.animateWithDuration(0.3, animations: { _ in
                    self.restaurantImageView.setImageWithURL(self.business.imageURL!)
                    self.restaurantImageView.alpha = 1.0
                })
            } else {
                restaurantImageView.image = UIImage(named: "noPhoto")
            }
            
            restaurantNameLabel.text = business.name
            
            if let reviewCount = business.reviewCount {
                reviewCountLabel.text = "\(reviewCount) reviews"
            } else {
                reviewCountLabel.text = "No Reviews"
            }
            
            if business.ratingImageURL != nil {
                ratingImageView.setImageWithURL(business.ratingImageURL!)
            } else{
                ratingImageView.image = UIImage(named: "noPhoto")
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
