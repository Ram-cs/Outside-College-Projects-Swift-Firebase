//
//  UberHandler.swift
//  Rider For Uber App
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import Firebase

protocol UberController: class {
    func canCallUber(delegateCalled: Bool)
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String)
    func getDriverLocaton(lat: Double, long: Double)
}
class UberHandler {
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    private static var _instances = UberHandler();
    static var Instances: UberHandler {
        return _instances
    }
    
    weak var delegate: UberController?
    //CAllED UBER
    func observeMessageForRider() {
        DBprovider.instances.dbUberRequest.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: true)
                    }
                }
            }
        }
        
        //UBER ACCEPTED
        DBprovider.instances.dbUberAccepted.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String{
                    if self.driver == "" {
                      self.driver = name
                        self.delegate?.driverAcceptedRequest(requestAccepted: true, driverName: self.driver)
                    }
                }
            }
        }
        //CANCEL UBER
        DBprovider.instances.dbUberRequest.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: false)
                    }
                }
            }
        }
        
        //DRIVER CANCELLED UBER
        DBprovider.instances.dbUberRequest.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.driver {
                        self.driver = ""
                        self.delegate?.driverAcceptedRequest(requestAccepted: false, driverName: name)
                    }
                }
            }
        }
        
        //GET THE RIDER LOCATION
        DBprovider.instances.dbUberAccepted.observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
               if let name = data[Constants.EMAIL] as? String {
                    if name == self.driver {
                        if let latitude = data[Constants.LATITUDE] as? Double {
                            if let longitude = data[Constants.LONGITUDE] as? Double {
                               self.delegate?.getDriverLocaton(lat: latitude, long: longitude)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func uberRequest(email: String, latitude: Double, longitude: Double) {
        let data: [String: Any] = [Constants.EMAIL: email, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        //storing data in the data base
        DBprovider.instances.dbReference.child(Constants.UBER_REQUEST).childByAutoId().setValue(data)
    }
    
    func cancelUber() {
        DBprovider.instances.dbUberRequest.child(rider_id).removeValue()
    }
    
    func updateRiderLocation(lat: Double, long: Double) {
        DBprovider.instances.dbUberRequest.child(rider_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long])
    }
}





