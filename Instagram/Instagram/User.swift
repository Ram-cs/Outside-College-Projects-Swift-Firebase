//
//  User.swift
//  Instagram
//
//  Created by Ram Yadav on 9/16/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

struct User {
    var userName: String
    var profileURL: String
    var uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.userName = dictionary["UserName"] as? String ?? ""
        self.profileURL = dictionary["ProfileURL"] as? String ?? ""
    }
}

