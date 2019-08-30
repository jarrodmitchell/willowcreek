//
//  DashboardViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/18/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase


protocol DashboardViewControllerDelegate {
    func workOrderRequestCountChanged()
    func workOrderAdded()
    func workOrderCompleted()
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DashboardViewControllerDelegate {
    
    //update table view when a work order is reviewed
    func workOrderRequestCountChanged() {
        if let requests = requestCount{
            requestCount = requests-1
        }
        
        workOrderCount+=1
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //update table view when a work order is completed
    func workOrderCompleted() {
        workOrderCount-=1
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //udpate tableview when a work order is added
    func workOrderAdded() {
        workOrderCount+=1
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var workOrders = [WorkOrder]()
    var announcements = [Announcement]()
    var messages = [Message]()
    
    var uId: String!
    var uName: String!
    var uType: String!
    var address: String?
    var workOrderCount: Int!
    var requestCount: Int?
    var messageCount: Int!
    var announcementCount: Int?
    var maintenance: Maintenance?
    var workOdersVCExists = false
    
    
    let tableViewCellTitles = [
        "management": ["Work Order Requests", "Active Work Orders", "Tenant Messages"],
        "tenants": ["Messages", "Active Work Orders", "Announcements"]]
    let collectionViewCellTitles = [
        "management": ["Send Announcement", "Send Package Alert", "Send Message To Tenant"],
        "tenants": ["Send Message To Management", "Send Work Order"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.title = uName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        print("nav controller count: " + String(navigationController!.viewControllers.count))
        
        print("dashboard open")
        
        if uType == "maintenance" {
            collectionView.isHidden = true
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            
            let cell = tableView.cellForRow(at: indexPath) as? InboxMenuTableViewCell
            
            //open work orders viewcontroller
            switch segue.identifier {
            case "workOrdersSegue":
                if let destination = segue.destination as? WorkOrdersViewController {
                    destination.uType = uType
                    destination.cellBackColor = cell?.backgroundColor
                    destination.workOrders = self.workOrders
                    destination.dashDelegate = self
                    
                    if let m = maintenance{
                        destination.maintenance = m
                    }
                    
                    if indexPath.section == 0 && uType != "maintenance" {
                        destination.vcTitle = "Work Order Requests"
                    }else{
                        destination.vcTitle = "Active Work Orders"
                    }
                }
                //open messages view controller
            case "messageSegue":
                if let destination = segue.destination as? MessageViewController {
                    destination.uId = self.uId
                    destination.uType = self.uType
                }
                //open announcements view controller
            case "announcementSegue":
                if let destination = segue.destination as? AnnouncementsViewController {
                    destination.announcements = self.announcements
                }
                //open messages viewcontroller
            case "messagesSegue":
                if let destination = segue.destination as? MessagesViewController {
                    destination.messages = self.messages
                    destination.uId = self.uId
                    destination.uType = self.uType
                }
            default:
                break
            }
        }else{
            //assign cell color to view table views in denstination viewcontroller
            if let destination = segue.destination as? WorkOrdersViewController {
                destination.uType = uType
                destination.cellBackColor = UIColor(displayP3Red: 41.0/255.0, green: 91.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                destination.workOrders = self.workOrders
                destination.dashDelegate = self
                destination.vcTitle = "Active Work Orders"
                
                if let m = maintenance{
                    destination.maintenance = m
                }
            }
        }
    }
    
    
    
    //log out of application
    @IBAction func signOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sign Out", style: .default) { (action) in
            do{
                try Auth.auth().signOut()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }catch let error as NSError{
                print("Error signing out: " + error.localizedDescription)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
