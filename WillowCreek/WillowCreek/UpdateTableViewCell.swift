//
//  UpdateTableViewCell.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/27/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var countBackView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
