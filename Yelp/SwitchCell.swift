//
//  SwitchCell.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/15/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate{
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var categoryLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onSwitchChange(sender: UISwitch) {
        print("value changed to \(sender.on)")
        delegate?.switchCell?(self, didChangeValue: categorySwitch.on)
    }
}
