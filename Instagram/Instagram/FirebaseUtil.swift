//
//  FirebaseUtil.swift
//  Instagram
//
//  Created by Ram Yadav on 9/17/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        let refs = Database.database().reference().child("users").child(uid)
        refs.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error) in
            print("Can't fetch the user name:", error)
        }
    }
}
