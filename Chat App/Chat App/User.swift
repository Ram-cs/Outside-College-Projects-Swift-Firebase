//
//  User.swift
//  Chat App
//
//  Created by Ram Yadav on 8/1/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String? //when setting id, dictionary explicitely needs to set ID, setValuesForKeys doesnt set ID
    var Email: String?
    var Password: String?
    var Name: String?
    var ProfileImage: String?
}
