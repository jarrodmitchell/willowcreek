//
//  CustomTableViewCell.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/20/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class InboxMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countBackgroundView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    var gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countBackgroundView.layer.cornerRadius = 18
        layer.cornerRadius = 4
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        gradientLayer.frame = self.frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let backView = UIView()
        backView.frame = self.frame
        backView.layer.insertSublayer(gradientLayer, at: 0)
        selectedBackgroundView?.insertSubview(backView, at: 0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
