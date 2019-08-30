//
//  WorkOrdersViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/23/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase


protocol WorkOrdersViewControllerDelegate {
    func dashboardDelegate()
}

class WorkOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkOrdersViewControllerDelegate {
    
    func dashboardDelegate() {
        self.dashDelegate.workOrderRequestCountChanged()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var cellBackColor: UIColor!
    var workOrders: [WorkOrder]!
    var updates: [Update]!
    var uType: String!
    var maintenance: Maintenance?
    var vcTitle: String!
    var dashDelegate: DashboardViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.backgroundColor = UIColor.clear
        title = vcTitle
        print("nav controller count: " + String(navigationController!.viewControllers.count))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "workOrderCell", for: indexPath) as! WorkOrderTableViewCell
        
        if let backColor = cellBackColor {
            cell.backgroundColor = backColor
        }
        
        cell.titleLabel.text = workOrders[indexPath.section].title
        let address = workOrders[indexPath.section].address.split(separator: ",")
        cell.addressLabel.text = String(address[0])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updates = [Update]()
        
        Firestore.firestore().collection("updates").whereField("workOrderId", isEqualTo: workOrders[indexPath.section].id!).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting updates: " + error.localizedDescription)
            }else{
                print("Successfully retrieved updates: " + snapshot!.count.description)
                if let data = snapshot?.documents {
                    print("segue")
                    if data.count > 0 {
                        for doc in data {
                            guard let title = doc.data()["title"] as? String else{continue}
                            guard let message = doc.data()["message"] as? String else{continue}
                            guard let date = doc.data()["timeStamp"] as? Timestamp else{continue}
                            let dateFormatter = DateFormatter()
                            dateFormatter.setLocalizedDateFormatFromTemplate("d-MMM-yyyy")
                            let fDate = dateFormatter.string(from: date.dateValue())
                            let update = Update.init(_title: title, _message: message, _date: fDate)
                            self.updates.append(update)
                            if data.count == self.updates.count {
                                DispatchQueue.main.async {
                                    if self.uType == "maintenance" {
                                        self.performSegue(withIdentifier: "updateSegue", sender: indexPath)
                                    }else{
                                        self.performSegue(withIdentifier: "workOrderSegue", sender: indexPath)
                                    }
                                    
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            if self.uType == "maintenance" {
                                self.performSegue(withIdentifier: "updateSegue", sender: indexPath)
                            }else{
                                self.performSegue(withIdentifier: "workOrderSegue", sender: indexPath)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else{return}
        
        switch segue.identifier {
        case "updateSegue":
            if let destination = segue.destination as? UpdateViewController {
                destination.workOrder = workOrders[indexPath.section]
                destination.uType = uType
                destination.workOrdersDelegate = self
                if let updates = updates {
                    destination.update = updates
                }
                
                if let maintenance = maintenance {
                    destination.maintenance = maintenance
                }
            }
        case "workOrderSegue":
            if let destination = segue.destination as? WorkOrderViewController {
                destination.workOrder = workOrders[indexPath.section]
                destination.uType = uType
                destination.workOrdersDelegate = self
                if let updates = updates {
                    destination.updates = updates.reversed()
                }
                
                if let maintenance = maintenance {
                    destination.maintenance = maintenance
                }
            }
        default:
            break
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
