//
//  DashboardViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/18/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var workOrders = [WorkOrder]()
    
    var uId: String!
    var uName: String!
    var uType: String!
    var address: String?
    var workOrderCount: Int!
    var requestCount: Int?
    var messageCount: Int?
    var announcementCount: Int?
    var maintenance: Maintenance?
    
    let tableViewCellTitles = [
        "management": ["Work Order Request", "Active Work Orders", "Tenant Messages"],
        "tenants": ["Messages", "Active Work Orders", "Announcements"]]
    let collectionViewCellTitles = [
        "management": ["Send Announcement", "Send Package Alert", "Send Message To Tenant"],
        "tenants": ["Send Message To Management", "Send Work Order"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = uName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.uId = self.uId
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
