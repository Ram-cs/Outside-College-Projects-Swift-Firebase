//
//  ViewController.swift
//  CurrentLocation
//
//  Created by Ram Yadav on 8/8/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var labelDisplay: UILabel!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        enableLocation()
    }

    @IBAction func currentLocation(_ sender: Any) {
        let center = currentLocation?.coordinate
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.myMap.setRegion(region, animated: true)
        
        myMap.removeAnnotations(myMap.annotations)
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = (currentLocation?.coordinate)!
        self.myMap.addAnnotation(annotation)
        
        let geoCord = CLGeocoder()
        geoCord.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            if error == nil {
                if let address = placemarks?[0].addressDictionary?["FormattedAddressLines"] as? [String] {
                let userAddress = address.joined(separator: ",")
                self.labelDisplay.text = userAddress
                    print(userAddress)
                }
            }
        }
    }

    func enableLocation() {
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
             locationManager?.startUpdatingLocation()
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }
}

