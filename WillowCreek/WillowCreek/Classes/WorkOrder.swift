//
//  WorkOrder.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/25/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation

class WorkOrder {
    var id: String!
    var tenantName: String!
    var address: String!
    var title: String!
    var message: String!
    var reviewed: Bool!
    var maintenanceStaff: [String]?
    
    init(_id: String, _tenantName: String, _address: String, _title: String, _message: String, _reviewed: Bool) {
        id = _id
        tenantName = _tenantName
        address = _address
        title = _title
        message = _message
        reviewed = _reviewed
    }
}
