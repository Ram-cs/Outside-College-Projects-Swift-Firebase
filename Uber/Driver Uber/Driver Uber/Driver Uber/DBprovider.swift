//
//  DBprovider.swift
//  Driver Uber
//
//  Created by Ram Yadav on 7/28/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBprovider {
    private static let _isntance = DBprovider();
    static var Instance: DBprovider {
        return _isntance;
    }
    
    var DBreference:DatabaseReference {
        return Database.database().reference();
    }
    
    var DBRef: DatabaseReference {
        return DBreference.child(Constants.DRIVER) //creating the driver as a parent in database
    }
    
    func saveData(email:String, password:String, withID: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL:email, Constants.PASSWORD: password, Constants.IS_DRIVER: true]
        DBRef.child(withID).child(Constants.DATA).setValue(data);
    }
    
    
}//class
