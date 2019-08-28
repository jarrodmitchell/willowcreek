//
//  Maintenance.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/27/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation
import Firebase

class Maintenance {
    let db = Firestore.firestore()
    var id: String!
    var name: String!
    var maintenance = [Maintenance]()
    var activeWorkOrderCount: Int?
    
    
    
    func getActiveWorkOrderCounts() {
        for m in maintenance {
            guard let mid = m.id else{continue}
            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("maintenance", arrayContains: mid).getDocuments { (snapshot, error) in
                if let error = error{
                    print("Error getting work order count: " + error.localizedDescription)
                }else{
                    print("Successfully retrieved work order count")
                    if let data = snapshot?.documents {
                        m.activeWorkOrderCount = data.count
                    }
                }
            }
        }
    }
    
    
    
    func getMaintenance() {
        maintenance = [Maintenance] ()
        db.collection("maintenance").getDocuments { (snapshot, error) in
            if let error = error{
                print("Error getting maintenance: " + error.localizedDescription)
            }else{
                print("Successfully retrieved maintenance")
                if let data = snapshot?.documents {
                    for person in data {
                        let id = person.documentID
                        guard let first = person.data()["first"] as? String, let last = person.data()["last"] as? String else{return}
                        let mp = Maintenance.init(_id: id, first: first, last: last)
                        self.maintenance.append(mp)
                    }
                }
            }
        }
    }
    
    
    
    init(_id: String, first: String, last: String) {
        id = _id
        name = first + " " + last
    }
}
