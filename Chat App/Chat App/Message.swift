//
//  Message.swift
//  Chat App
//
//  Created by Ram Yadav on 8/14/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    var fromId: String?
    var text: String?
    var toId: String?
    var timeStamp: NSNumber?
    
    func chatPartnerId()->String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }

}
