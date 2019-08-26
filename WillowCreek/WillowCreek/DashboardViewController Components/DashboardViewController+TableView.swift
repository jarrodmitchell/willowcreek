//
//  DashboardViewController+TableView.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/21/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation
import Firebase
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxMenuCell", for: indexPath) as! InboxMenuTableViewCell
        
        if let type = uType {
            cell.titleLabel.text = (tableViewCellTitles[type]!)[indexPath.section]
        }
        
        switch indexPath.section {
        case 0:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 255.0/255.0, green: 91.0/255.0, blue: 127.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 252.0/255.0, green: 153.0/255.0, blue: 112.0/255.0, alpha: 1.0))
        case 1:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 119.0/255.0, green: 165.0/255.0, blue: 248.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 213.0/255.0, green: 163.0/255.0, blue: 255.0/255.0, alpha: 1.0))
            cell.countLabel.text = String(workOrderCount)
        case 2:
            cell.setGradientBackground(colorOne: UIColor(displayP3Red: 159.0/255.0, green: 110.0/255.0, blue: 163.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 255.0/255.0, green: 116.0/255.0, blue: 164.0/255.0, alpha: 1.0))
        default:
            break;
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? InboxMenuTableViewCell
        let gradientLayer = cell!.gradientLayer
        
        if indexPath.section == 1 {
            showWorkOrdersController()  {
                guard let workOrderVC = self.storyboard?.instantiateViewController(withIdentifier: "activeWorkOrders") as? WorkOrdersViewController else {return}
                workOrderVC.cellGradientLayer = gradientLayer
                workOrderVC.workOrders = self.workOrders
                
                self.navigationController?.pushViewController(workOrderVC, animated: true)
            }
        }else if indexPath.section == 0 && uType == "tenants" {
            
        }else if indexPath.section == 2 && uType == "" {
            
        }else if indexPath.section == 0 {
            
        }else{
            
        }
    }
    
    
    
    func showWorkOrdersController(completionHandler: @escaping () -> Void) {
        
        db.collection("workOrders").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting work orders: " + error.localizedDescription)
            }else{
                print("Successfully retrieved work orders")
                if snapshot!.count > 0 {
                    guard let data = snapshot?.documents else{return}
                    
                    self.workOrders = [WorkOrder]()
                    var count = 0
                    
                    for workOrder in data {
                        let id = workOrder.documentID
                        guard let tenantId = workOrder.data()["tenant"] as? String else {return}
                        guard let title = workOrder.data()["title"] as? String else {return}
                        guard let message = workOrder.data()["message"] as? String else {return}
                        self.db.collection("tenants").document(tenantId).addSnapshotListener({ (snapshot, error) in
                            
                            if let error = error {
                                print("Error retrieving tenant data: " + error.localizedDescription)
                            }else{
                                print("Successfuly retrieved tenant info")
                                guard let fName = snapshot!.data()!["first"] as? String else {return}
                                guard let lName = snapshot!.data()!["last"] as? String else {return}
                                guard let address = snapshot?.data()!["address"]  as? String else {return}
                                
                                self.workOrders.append(WorkOrder(_id: id, _tenantName: fName + " " + lName, _address: address, _title: title, _message: message))
                                print("work order count: " + String(self.workOrders.count))
                                
                                count+=1
                                print("count: " + String(count))
                                if count == data.count {
                                    print("completion")
                                    completionHandler()
                                }
                            }
                        })
                    }
                }
            }
        }
    }

}
