//
//  DistanceCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DistanceCellDelegate{
    optional func distancePreferrence(distanceCell: DistanceCell, didPickDistance value: Int)
}

class DistanceCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
}

