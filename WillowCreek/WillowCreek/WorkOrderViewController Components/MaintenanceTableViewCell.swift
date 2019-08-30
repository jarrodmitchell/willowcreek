//
//  MaintenanceTableViewCell.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/27/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class MaintenanceTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var assignmentCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
