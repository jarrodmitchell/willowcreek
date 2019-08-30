//
//  Message.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/30/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation

class Message {
    var date: String!
    var sender: String!
    var recipient: String!
    var message: String!
    var title: String!
    var viewed: Bool!
    
    init(_date: String, _sender: String, _recipient: String, _message: String, _title: String, _viewed: Bool) {
        date = _date
        sender = _sender
        recipient = _recipient
        message = _message
        title = _title
        viewed = _viewed
    }
}
