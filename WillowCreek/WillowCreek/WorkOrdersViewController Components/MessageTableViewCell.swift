//
//  MessageTableViewCell.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/25/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        layer.cornerRadius = 4
        print("New Cell")
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
