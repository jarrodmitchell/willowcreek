//
//  Update.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/29/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation

class Update {
    var title: String!
    var message: String!
    var date: String!
    
    init(_title: String, _message: String, _date: String) {
        self.title = _title
        self.message = _message
        self.date = _date
    }
}
