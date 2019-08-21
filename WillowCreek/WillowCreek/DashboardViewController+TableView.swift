//
//  DashboardViewController+TableView.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/21/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation
import UIKit

extension DashboardViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTableViewCell
        
        if let type = uType {
            cell.titleLabel.text = (tableViewCellTitles[type]!)[indexPath.section]
        }
        
        switch indexPath.section {
        case 0:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 255.0/255.0, green: 91.0/255.0, blue: 127.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 252.0/255.0, green: 153.0/255.0, blue: 112.0/255.0, alpha: 1.0))
        case 1:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 119.0/255.0, green: 165.0/255.0, blue: 248.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 213.0/255.0, green: 163.0/255.0, blue: 255.0/255.0, alpha: 1.0))
        case 2:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 159.0/255.0, green: 110.0/255.0, blue: 163.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 255.0/255.0, green: 116.0/255.0, blue: 164.0/255.0, alpha: 1.0))
        default:
            break;
        }
        
        return cell
    }

}
