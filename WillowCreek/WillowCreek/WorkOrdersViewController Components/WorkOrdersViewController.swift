//
//  WorkOrdersViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/23/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase



protocol UpdateTableViewDelegate {
    func update()
}



class WorkOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateTableViewDelegate {
    func update() {
        self.view.reloadInputViews()
    }
    
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var cellGradientLayer: CAGradientLayer?
    var workOrders: [WorkOrder]!
    var uType: String!
    var maintenance: Maintenance?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.backgroundColor = UIColor.clear
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let workOrders = workOrders {
            return workOrders.count
        }else{print("nope"); return 0}
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        if let gradientLayer = cellGradientLayer {
            cell.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        cell.titleLabel.text = workOrders[indexPath.section].title
        cell.addressLabel.text = workOrders[indexPath.section].address
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        maintenance?.getActiveWorkOrderCounts()
        
        let workOrderVC = self.storyboard?.instantiateViewController(withIdentifier: "workOrder") as! WorkOrderViewController
        workOrderVC.workOrder = workOrders[indexPath.section]
        workOrderVC.uType = uType
        if let maintenance = maintenance {
            workOrderVC.maintenance = maintenance
        }
        self.navigationController?.pushViewController(workOrderVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
