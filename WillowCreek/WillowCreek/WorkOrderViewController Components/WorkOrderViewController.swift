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
    var update: [String]?
    var maintenance: Maintenance?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTableView.delegate = self
        updateTableView.dataSource = self
        
        titleLabel.text = workOrder.title
        messageTextView.text = workOrder.message
        backgroundView.layer.cornerRadius = 6
        finishButton.isHidden = true
        
        if uType == "tenants" {
            workersLabel.isHidden = false
        }else{
            assignMaintenanceLabel.isHidden = false
            updateTableView.allowsMultipleSelection = true
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uType == "tenants" {
            return update?.count ?? 0
        }else{
            if let maintenance = maintenance {
                print("rows: " + String(maintenance.maintenance.count))
                return maintenance.maintenance.count
            }else{return 0}
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if uType == "tenants" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdateTableViewCell {
                
            }
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
        let cell = tableView.cellForRow(at: indexPath) as! MaintenanceTableViewCell
        cell.accessoryType = .checkmark
        
        finishButton.isHidden = false
    }
    
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as! MaintenanceTableViewCell
        cell.accessoryType = .none
        
        if tableView.indexPathsForSelectedRows?.count == nil{
            finishButton.isHidden = true
        }
    }
    
    
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Assign Personnel", message: "Please confirm selections", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            if let id = self.workOrder.id {
                var selectedPersonnel = [String]()
                for index in self.updateTableView.indexPathsForSelectedRows! {
                    guard let id = self.maintenance?.maintenance[index.row].id else{return}
                    selectedPersonnel.append(id)
                }
                Firestore.firestore().collection("workOrders").document(id).setData(["maintenance" : selectedPersonnel, "reviewed" : true], merge: true, completion: { (error) in
                    if let error = error {
                        print("Error adding maintenance workers to work order: " + error.localizedDescription)
                    }else{print("Success adding maintenance workers to work order")}
                })
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
