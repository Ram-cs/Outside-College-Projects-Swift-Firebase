//
//  UberHandler.swift
//  Driver Application
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    func aceptUber(long: Double, lat: Double)
    func riderCancelledUber();
    func driverCancelledUber();
    func updateRiderLocation(lati: Double, long: Double)
}
class UberHandler {
    
    var rider = ""
    var driver = ""
    var driver_id = ""
    
    weak var delegate: UberController?
    
    private static var _instances = UberHandler()
    static var Instances: UberHandler {
        return _instances
    }
    
    func observeMessageForDriver() {
        //OBSERVE IF GET UBER
        DBprovider.Instance.dbUberRequest.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        self.delegate?.aceptUber(long: latitude, lat: longitude)
                    }
                }
                if let name = data[Constants.EMAIL] as? String {
                    self.rider = name
                }
            }
        }
        
        //OBSERVEVE IF UBER REQUEST CANCELLED
        DBprovider.Instance.dbUberRequest.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.rider {
                        self.rider = ""
                        self.delegate?.riderCancelledUber()
                    }
                }
            }
        }
        
        //DRIVER ACCEPTED UBER
        DBprovider.Instance.dbUberAccept.observe(DataEventType.childAdded) { (snapshot:DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.driver {
                        self.driver_id = snapshot.key
                    }
                }
            }
        }
        
        //DRIVER CANCELLED UBER
        DBprovider.Instance.dbUberAccept.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.driver {
                      self.delegate?.driverCancelledUber()
                    }
                }
            }
        }
        
        //GET THE DRIVER LOCATION
        DBprovider.Instance.dbUberRequest.observe(DataEventType.childChanged) { (snapshot:DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.EMAIL] as? String {
                    if name == self.rider {
                        if let latitude = data[Constants.LATITUDE] as? Double {
                            if let longitude = data[Constants.LONGITUDE] as? Double {
                               self.delegate?.updateRiderLocation(lati: latitude, long: longitude)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func uberAccepted(lat: Double, long: Double) {
        let data: [String: Any] = [Constants.EMAIL: driver, Constants.LATITUDE: lat, Constants.LONGITUDE: long]
        DBprovider.Instance.dbUberAccept.childByAutoId().setValue(data)
    }
    
    func driverCancelledUber() {
        DBprovider.Instance.dbUberAccept.child(driver_id).removeValue()
    }
    
    func updateDriverLocation(lat: Double, long: Double) {
        DBprovider.Instance.dbUberAccept.child(driver_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long])
    }
}




















