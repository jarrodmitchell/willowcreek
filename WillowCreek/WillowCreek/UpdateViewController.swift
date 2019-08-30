//
//  UpdateViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/28/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase


protocol UpdateViewControllerDelegate {
    func reload()
}

class UpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateViewControllerDelegate {
    func reload() {
        DispatchQueue.main.async {
            
            self.updateTableView.reloadData()
        }
    }
    

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var workersLabel: UILabel!
    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addUpdateButton: UIButton!
    @IBOutlet weak var workOrderCompleteButton: UIButton!
    
    var workOrder: WorkOrder!
    var uType: String!
    var status: Bool!
    var update: [Update]?
    var maintenance: Maintenance?
    var workOrdersDelegate: WorkOrdersViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateTableView.delegate = self
        updateTableView.dataSource = self
        updateTableView.estimatedRowHeight = 130
        updateTableView.rowHeight = UITableView.automaticDimension
        
        titleLabel.text = workOrder.title
        messageTextView.text = workOrder.message
        backgroundView.layer.cornerRadius = 6
        addUpdateButton.layer.cornerRadius = 4
        workOrderCompleteButton.layer.cornerRadius = 4
        
        if update != nil {
            update?.reverse()
        }
        
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
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let update = update {
            return update.count
        }else{return 0}
    }
    
    
    
    //display updates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdateTableViewCell, let update = update?[indexPath.row] {
            cell.titleLabel.text = update.title
            cell.messageLabel.text = update.message
            cell.dateLabel.text = update.date
            cell.countBackView.layer.cornerRadius = 25
            cell.countLabel.text = String(indexPath.row + 1)
            return cell
        }
        return UITableViewCell.init()
    }
    
    
    
    @IBAction func addUpdateButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addUpdateSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.title = "Add Update"
            destination.workOrderId = workOrder.id
            destination.uType = uType
            destination.index = 0
            destination.uId = maintenance?.id
            destination.updateDelegate = self
        }
    }
    
    
    
    //work order is updated to show completion
    @IBAction func workOrderCompleteButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Completion", message: "Please confirm that that the work order is complete", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            if let id = self.workOrder.id {
                Firestore.firestore().collection("workOrders").document(id).setData(["active" : false], merge: true, completion: { (error) in
                    if let error = error {
                        print("Error setting work order as complete: " + error.localizedDescription)
                    }else{print("Success setting work order as complete")
                        DispatchQueue.main.async {
                            self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
                        }
                    }
                })
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
