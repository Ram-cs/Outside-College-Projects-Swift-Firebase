//
//  DBProvider.swift
//  Driver Application
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBprovider {
    private static let _isntance = DBprovider();
    static var Instance: DBprovider {
        return _isntance;
    }
    
    //reference
    var DBreference:DatabaseReference {
        return Database.database().reference();
    }
    
    //driver
    var DBRef: DatabaseReference {
        return DBreference.child(Constants.DRIVER) //creating the driver as a parent in database
    }
    
    //request Uber
    var dbUberRequest: DatabaseReference {
        return DBreference.child(Constants.UBER_REQUEST)
    }
    
    //Uber Accepted
    var dbUberAccept: DatabaseReference {
        return DBreference.child(Constants.UBER_ACCEPT)
    }
    func saveData(email:String, password:String, withID: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL:email, Constants.PASSWORD: password, Constants.IS_DRIVER: true]
        DBRef.child(withID).child(Constants.DATA).setValue(data);
    }
    
    
}//class
