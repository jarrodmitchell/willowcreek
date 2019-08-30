//
//  WorkOrderViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/25/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase

class WorkOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var assignMaintenanceLabel: UILabel!
    @IBOutlet weak var workersLabel: UILabel!
    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    var workOrder: WorkOrder!
    var uType: String!
    var status: Bool!
    var updates: [Update]?
    var maintenance: Maintenance?
    var workOrdersDelegate: WorkOrdersViewControllerDelegate!
    var addMaintenance = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTableView.delegate = self
        updateTableView.dataSource = self
        updateTableView.estimatedRowHeight = 130
        updateTableView.rowHeight = UITableView.automaticDimension
        
        let address = workOrder.address.split(separator: ",")
        title = String(address[0])
        
        titleLabel.text = workOrder.title
        messageTextView.text = workOrder.message
        backgroundView.layer.cornerRadius = 6
        finishButton.isHidden = true
        
        //display workers assinged to work order if a tenant is viewing a work order or manangement is viewing a reviewed order display updates
        if uType == "tenants" || workOrder.reviewed == true {
            var workers = "Workers:  "
            if let maintenance = workOrder.maintenanceStaff {
                var count = 0
                for personnel in maintenance {
                    print(personnel)
                    workers.append(personnel)
                    count+=1
                    if count != maintenance.count {
                        workers.append(", ")
                    }
                }
                workersLabel.text = workers
            }
            workersLabel.isHidden = false
        }else{
            assignMaintenanceLabel.isHidden = false
            updateTableView.allowsMultipleSelection = true
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uType == "tenants" || workOrder.reviewed == true {
            return updates?.count ?? 0
        }else{
            if let maintenance = maintenance {
                print("rows: " + String(maintenance.maintenance.count))
                return maintenance.maintenance.count
            }else{return 0}
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here")
        //if a tenant is viewing a work order or manangement is viewing a reviewed order display updates
        if uType == "tenants" || workOrder.reviewed == true {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell2", for: indexPath) as? UpdateTableViewCell, let update = updates?[indexPath.row] {
                cell.titleLabel.text = update.title
                cell.messageLabel.text = update.message
                cell.dateLabel.text = update.date
                cell.countBackView.layer.cornerRadius = 25
                cell.countLabel.text = String(indexPath.row + 1)
                return cell
            }
            //if manangement is viewing an unreviewed work order show maintence
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "maintenanceCell", for: indexPath) as? MaintenanceTableViewCell, let maintenance = maintenance {
                cell.name.text = maintenance.maintenance[indexPath.row].name
                cell.assignmentCount.text = String(maintenance.maintenance[indexPath.row].activeWorkOrderCount ?? 0)
                print("Cell created")
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if uType == "management" && workOrder.reviewed == false {
            let cell = tableView.cellForRow(at: indexPath) as! MaintenanceTableViewCell
            cell.accessoryType = .checkmark
            
            finishButton.isHidden = false
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as! MaintenanceTableViewCell
        cell.accessoryType = .none
        
        if tableView.indexPathsForSelectedRows?.count == nil{
            finishButton.isHidden = true
        }
    }
    
    
    
    //update dashboard tableview
    override func viewWillDisappear(_ animated: Bool) {
        if addMaintenance == true {
            workOrdersDelegate.dashboardDelegate()
        }
    }
    
    
    
    //add selected maintenace staff to work order
    @IBAction func finishButtonTapped(_ sender: Any) {
        if let id = self.workOrder.id {
            var selectedPersonnel = [String]()
            for index in self.updateTableView.indexPathsForSelectedRows! {
                guard let id = self.maintenance?.maintenance[index.row].id else{return}
                selectedPersonnel.append(id)
            }
            Firestore.firestore().collection("workOrders").document(id).setData(["maintenance" : selectedPersonnel, "reviewed" : true], merge: true, completion: { (error) in
                if let error = error {
                    print("Error adding maintenance workers to work order: " + error.localizedDescription)
                }else{
                    print("Success added maintenance workers to work order")
                    self.addMaintenance = true
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
                }
            })
        }
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
