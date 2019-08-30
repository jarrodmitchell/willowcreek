//
//  Tenant.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/30/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation

class Tenant {
    var id: String!
    var name: String!
    var address: String!
    
    init(_name: String, _address: String, _id: String) {
        self.name = _name
        self.address = _address
        self.id = _id
    }
}
