//
//  DealCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate{
    optional func dealCellSwitch(dealCell: DealCell, didChangeValue value: Bool)
}

class DealCell: UITableViewCell {

    @IBOutlet weak var dealSwitch: UISwitch!
    
    weak var delegate: DealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func onDealSwitchChange(sender: UISwitch) {
        print("deal changed to \(sender.on)")
        delegate?.dealCellSwitch?(self, didChangeValue: dealSwitch.on)
    }
}
