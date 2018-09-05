//
//  MyCourtUser.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit


class MyCourtUser: NSObject {
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

