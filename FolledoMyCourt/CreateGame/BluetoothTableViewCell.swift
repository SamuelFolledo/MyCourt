//
//  BluetoothTableViewCell.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 8/16/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
