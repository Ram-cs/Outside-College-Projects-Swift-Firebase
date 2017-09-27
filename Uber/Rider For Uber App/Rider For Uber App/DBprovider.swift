//
//  DBprovider.swift
//  
//
//  Created by Ram Yadav on 8/8/17.
//
//

import Foundation
import Firebase

class DBprovider {
    private static var _instances = DBprovider()
    static var instances: DBprovider {
        return _instances
    }
    
    //database reference
    var dbReference: DatabaseReference {
        return Database.database().reference()
    }
    
    var dbUberRequest: DatabaseReference {
        return dbReference.child(Constants.UBER_REQUEST)
    }
    
    var dbUberAccepted: DatabaseReference {
        return dbReference.child(Constants.UBER_ACCEPT)
    }
    
    func storeData(userID: String, email: String, password: String) {
        let dictionary: [String: Any] = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.IS_RIDER: true]
        self.dbReference.child("Rider").child(userID).child("Data").setValue(dictionary)
    }
}
