//
//  Announcement.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/30/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation

class Announcement {
    var message: String!
    var date: String!
    
    init(_date: String, _message: String) {
        self.message = _message
        self.date = _date
    }
}
