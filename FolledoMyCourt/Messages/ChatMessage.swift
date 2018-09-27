//
//  ChatMessage.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatMessage: NSObject { //ep.9
    
    var fromId: String? //ep.9
    var text: String? //ep.9
    var timeStamp: NSNumber? //ep.9
    var userUid: String? //ep.9
    
    var imageUrl: String? //ep.17 21mins
    var imageHeight: NSNumber? //ep.18 5mins
    var imageWidth: NSNumber? //ep.18 5mins
    
    init(dictionary: [String: Any]) { //ep.9 constructor
        self.fromId = dictionary["fromId"] as? String //ep.9
        self.text = dictionary["text"] as? String //ep.9
        self.userUid = dictionary["userUid"] as? String //ep.9
        self.timeStamp = dictionary["timeStamp"] as? NSNumber //ep.9
        self.imageUrl = dictionary["imageUrl"] as? String //ep.17 21mins
        self.imageHeight = dictionary["imageHeight"] as? NSNumber //ep.18 5mins
        self.imageWidth = dictionary["imageWidth"] as? NSNumber //ep.18 5mins
    }
    
    
    func chatPartnerId() -> String {
//        var chatPartnerId: String? //ep.11 //we have a dilemma where if I send a message to Raquel, in Raquel's MessagesController, it would show her profileImageUrl instead of my image, so this will switch if the current user uid is the same as the fromId
//        if message?.fromId == Auth.auth().currentUser?.uid { //ep.11 if the message.fromId is the same as the current user, then set id to the chat, not the sender
//            chatPartnerId = message?.userUid //ep.11
//        } else {
//            chatPartnerId = message?.fromId //ep.11
//        }
        if fromId == Auth.auth().currentUser?.uid {
            return userUid!
        } else {
            return fromId!
        }
    }
}
