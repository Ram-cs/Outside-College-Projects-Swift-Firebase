//
//  RiderVC.swift
//  Rider For Uber App
//
//  Created by Ram Yadav on 8/8/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, UberController {
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var canCallUberButton: UIButton!
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var driverLocation: CLLocationCoordinate2D?
    
     var canCallUber = true;
    private var cancelUber = false;
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocation()
        UberHandler.Instances.observeMessageForRider()
        UberHandler.Instances.delegate = self
    }
    
//    func locationBarBotton() {
//        let button: UIButton = UIButton(type:.custom)
//        button.setImage(UIImage(named: "currentLocationImage"), for: UIControlState.normal)
//    //  button.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
//        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(findCurrentLocation)))
//        button.isUserInteractionEnabled = true
//        let barbutton = UIBarButtonItem.init(customView: button)
//        self.navigationItem.leftBarButtonItem = barbutton
//    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instances.signOut() == true {
            if !canCallUber {
                UberHandler.Instances.cancelUber()
                timer.invalidate()
            }
            dismiss(animated: true, completion: nil)
        } else {
            self.errorAlert(titile: "LogOut Fail!", message: "Please try again Later")
        }
    }
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            canCallUberButton.setTitle("Cancel", for: UIControlState.normal)
            canCallUber = false
        } else {
            canCallUberButton.setTitle("Call Uber", for: UIControlState.normal)
            canCallUber = true
        }
    }

    @IBAction func callUber(_ sender: Any) {
        if currentLocation != nil {
            if canCallUber {
                UberHandler.Instances.uberRequest(email: UberHandler.Instances.rider, latitude: (self.currentLocation?.longitude)!, longitude: (currentLocation?.longitude)!)
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(self.updateRiderLocatoin), userInfo: nil, repeats: true)
            } else {
                cancelUber = true; //if we don't have rider location
                //CANCEL UBER MEANS EARISING THE REQUESTED DATA
                UberHandler.Instances.cancelUber()
                timer.invalidate()
            }
        }
    }
    
    func getDriverLocaton(lat: Double, long: Double) {
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        if !self.cancelUber {
            errorAlert(titile: "Uber Accepted", message: "\(driverName) accepted uber")
        } else {
           UberHandler.Instances.cancelUber()
            timer.invalidate()
            errorAlert(titile: "Uber Cancelled", message: "driver canceled uber")
        }
        self.cancelUber = false
    }
    
    func updateRiderLocatoin() {
        UberHandler.Instances.updateRiderLocation(lat: (currentLocation?.latitude)!, long: (currentLocation?.longitude)!)
    }
    
    
    func errorAlert(titile: String, message: String) {
        let alert = UIAlertController(title: titile, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}



extension RiderVC: CLLocationManagerDelegate {
    func initializeLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager?.location?.coordinate {
            currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: currentLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.myMap.setRegion(region, animated: true)
            self.myMap.removeAnnotations(self.myMap.annotations) //remove all the annotaion
            if driverLocation != nil {
                if !self.canCallUber { //Check if uber already on the ride
                    let annotation = MKPointAnnotation()
                    annotation.title = "Diver location"
                    annotation.coordinate = driverLocation!
                    self.myMap.addAnnotation(annotation)
                }
            }
            let annotation = MKPointAnnotation()
            annotation.title = "Current Location"
            annotation.coordinate = currentLocation!
            
            self.myMap.addAnnotation(annotation)
        }
    }
    
//    func findCurrentLocation() {
//        if ((currentLocation) != nil) {
//            let region = MKCoordinateRegion(center: currentLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            self.myMap.setRegion(region, animated: true)
//            
//            
//           self.myMap.removeAnnotations(self.myMap.annotations) //remove all the annotaion
//            
//            let annotation = MKPointAnnotation()
//            annotation.title = "Current Location"
//            annotation.coordinate = currentLocation!
//            
//            self.myMap.addAnnotation(annotation)
    
//            let geoCord = CLGeocoder()
//            
//            geoCord.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemark, error) in
//                if error == nil {
//                    if let placeName = placemark?[0].addressDictionary?["FormattedAddressLines"] as? [String] {
//                       let name = placeName.joined(separator: ",")
//                       self.labelText.text = name
//                    }
//                } else {
//                    fatalError("Error with getting name of the location\(self.currentLocation!)")
//                    self.labelText.text = "Error Occured!"
//                }
//            })
//            
//        } else {
//            fatalError("Location unable to find, Current Location is: \(String(describing: currentLocation))")
//  }
        
//    }

}












