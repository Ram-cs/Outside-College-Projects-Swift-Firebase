//
//  Post.swift
//  Instagram
//
//  Created by Ram Yadav on 9/14/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation

struct Post {
    let user: User
    var imageURL: String
    var caption: String
    var creationDate: Date
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        imageURL = dictionary["imageURL"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
        
        let secondSince1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: secondSince1970)
    }
}
