//
//  ChatMessage.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ChatMessage: NSObject { //ep.9
    
    var fromId: String? //ep.9
    var text: String? //ep.9
    var timeStamp: NSNumber? //ep.9
    var userUid: String? //ep.9
    
    init(dictionary: [String: Any]) { //ep.9
        self.fromId = dictionary["fromId"] as? String //ep.9
        self.text = dictionary["text"] as? String //ep.9
        self.userUid = dictionary["userUid"] as? String //ep.9
        self.timeStamp = dictionary["timeStamp"] as? NSNumber //ep.9
    }
}
