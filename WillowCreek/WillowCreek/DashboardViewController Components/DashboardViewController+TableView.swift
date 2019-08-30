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
        if uType == "maintenance" {
            return 1
        }
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
            if type == "maintenance" {
                cell.titleLabel.text = "Active Work Orders"
            }else{
                cell.titleLabel.text = (tableViewCellTitles[type]!)[indexPath.section]
            }
        }
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIColor(displayP3Red: 49.0/255.0, green: 146.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            if uType == "management" || uType == "maintenance"{
                cell.countLabel.text = String(requestCount ?? 0)
            }else{
                cell.countLabel.text = String(messageCount ?? 0)
            }
        case 1:
            cell.backgroundColor = UIColor(displayP3Red: 41.0/255.0, green: 91.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            print(String(workOrderCount))
            cell.countLabel.text = String(workOrderCount)
        case 2:
            cell.backgroundColor = UIColor(displayP3Red: 63.0/255.0, green: 49.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            if uType == "tenants" {
                cell.countLabel.text = String(announcementCount ?? 0)
            }else{
                cell.countLabel.text = String(messageCount ?? 0)
            }
        default:
            break;
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let maintenance = maintenance {
            maintenance.getActiveWorkOrderCounts()
        }
        
        //go to messages vc
        if indexPath.section == 0 && uType == "tenants" {
            db.collection("messages").whereField("recipient", isEqualTo: uId!).limit(to: 50).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting messages: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved messages")
                    guard let snapshot = snapshot else{return}
                    
                    self.parseMessages(snapshot: snapshot, completionHandler: {
                        self.performSegue(withIdentifier: "messagesSegue", sender: indexPath)
                    })
                }
            }
            //go to work order vc //display active workorders if user is maintencance
        }else if indexPath.section == 0 && uType == "maintenance" {
            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: true).whereField("maintenance", arrayContains: maintenance!.id!).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting work orders: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved work orders")
                    guard let snapshot = snapshot else{return}
                    
                    self.parseWorkOrders(snapshot: snapshot)  {
                        self.performSegue(withIdentifier: "workOrdersSegue", sender: indexPath)
                    }
                }
            }
            //go to work order vc // display pening  work orders if user is management
        }else if indexPath.section == 0 {
            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: false).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting work orders: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved work orders")
                    guard let snapshot = snapshot else{return}
                    
                    self.parseWorkOrders(snapshot: snapshot)  {
                        self.performSegue(withIdentifier: "workOrdersSegue", sender: indexPath)
                    }
                }
            }
            //go to work order vc // display active work orders if user is tenant
        }else if indexPath.section == 1 && uType == "tenants" {
            guard let address = address else{return}
            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("address", isEqualTo: address).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting work orders: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved work orders")
                    guard let snapshot = snapshot else{return}
                    
                    self.parseWorkOrders(snapshot: snapshot)  {
                        self.performSegue(withIdentifier: "workOrdersSegue", sender: indexPath)
                    }
                }
            }
        }
            //go to work order vc // display active work orders if user is management
        else if indexPath.section == 1 {
            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: true).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting work orders: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved work orders")
                    guard let snapshot = snapshot else{return}
                    
                    self.parseWorkOrders(snapshot: snapshot)  {
                        self.performSegue(withIdentifier: "workOrdersSegue", sender: indexPath)
                    }
                }
            }
            //go to messages vc // display announcemnts if user is tenant
        }else if indexPath.section == 2 && uType == "tenants" {
            db.collection("announcements").limit(to: 50).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting announcements: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved announcements")
                    guard let snapshot = snapshot else{return}
                    self.parseAnnouncements(snapshot: snapshot, completionHandler: {
                        self.performSegue(withIdentifier: "announcementSegue", sender: indexPath)
                    })
                }
            }
        }else{
            ////go to message vc // display messages if user is management
            db.collection("messages").whereField("recipient", isEqualTo: "management").limit(to: 50).order(by: "timeStamp", descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting messages: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved messages")
                    guard let snapshot = snapshot else{return}
                    print("Count: " + String(snapshot.documents.count))
                    self.parseMessages(snapshot: snapshot, completionHandler: {
                        self.performSegue(withIdentifier: "messagesSegue", sender: indexPath)
                    })
                }
            }
        }
    }
    
    
    
    func parseMessages(snapshot: QuerySnapshot, completionHandler: @escaping () -> Void) {
        var count = 0
        messages = [Message]()
        if snapshot.documents.count > 0 {
            for doc in snapshot.documents {
                guard let title = doc.data()["title"] as? String else{return}
                guard let message = doc.data()["message"] as? String else{return}
                guard let sender = doc.data()["sender"] as? String else{return}
                guard let recipient = doc.data()["recipient"] as? String else{return}
                guard let viewed = doc.data()["viewed"] as? Bool else{return}
                guard let date = doc.data()["timeStamp"] as? Timestamp else{return}
                print(title)
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("d-MMM-yyyy")
                let fDate = dateFormatter.string(from: date.dateValue())
                
                let newMessage = Message(_date: fDate, _sender: sender, _recipient: recipient, _message: message, _title: title, _viewed: viewed)
                self.messages.append(newMessage)
                count += 1
                print(String(count)  + " : " + String(snapshot.documents.count))
                if count == snapshot.count {
                    completionHandler()
                    print("completion")
                }
            }
        }
    }
    
    
    
    func parseAnnouncements(snapshot: QuerySnapshot, completionHandler: @escaping () -> Void) {
        var count = 0
        announcements = [Announcement]()
        if snapshot.count > 0 {
            for doc in snapshot.documents {
                guard let message = doc.data()["message"] as? String else{return}
                guard let date = doc.data()["timeStamp"] as? Timestamp else{return}
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("d-MMM-yyyy")
                let fDate = dateFormatter.string(from: date.dateValue())
                let announce = Announcement(_date: fDate, _message: message)
                self.announcements.append(announce)
                count += 1
                if count == snapshot.count {
                    completionHandler()
                }
            }
        }
    }
    
    
    
    func parseWorkOrders(snapshot: QuerySnapshot, completionHandler: @escaping () -> Void) {
        print(String(snapshot.count))
        if snapshot.count > 0 {
            let data = snapshot.documents
            
            self.workOrders = [WorkOrder]()
            var count = 0
            
            for workOrder in data {
                print("Sorting")
                let id = workOrder.documentID
                guard let tenantId = workOrder.data()["tenant"] as? String else {return}
                guard let title = workOrder.data()["title"] as? String else {return}
                guard let message = workOrder.data()["message"] as? String else {return}
                guard let reviewed = workOrder.data()["reviewed"] as? Bool else {return}
                var mStaff = [String]()
                if reviewed == true {
                    if let maintenanceStaff = workOrder.data()["maintenance"] as? [String] {
                        for p in maintenanceStaff {
                            for m in maintenance!.maintenance {
                                if p == m.id {
                                    mStaff.append(m.name)
                                }
                            }
                        }
                    }
                }
                self.db.collection("tenants").document(tenantId).addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        print("Error retrieving tenant data: " + error.localizedDescription)
                    }else{
                        print("Successfuly retrieved tenant info")
                        guard let fName = snapshot!.data()!["first"] as? String else {return}
                        guard let lName = snapshot!.data()!["last"] as? String else {return}
                        guard let address = snapshot?.data()!["address"]  as? String else {return}
                        
                        self.workOrders.append(WorkOrder(_id: id, _tenantName: fName + " " + lName, _address: address, _title: title, _message: message, _reviewed: reviewed))
                        if mStaff.count != 0 {
                            self.workOrders.last?.maintenanceStaff = mStaff
                        }
                        
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
