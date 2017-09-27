//
//  DriverVC.swift
//  Driver Uber
//
//  Created by Ram Yadav on 7/28/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager();
    private var userLoaction: CLLocationCoordinate2D?;
    private var riderLocation: CLLocationCoordinate2D?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
    }
    

    func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            userLoaction = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLoaction!, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
            
            //remove the preious annotation
            mapView.removeAnnotations(mapView.annotations)
            
            let annotaton = MKPointAnnotation()
            annotaton.coordinate = userLoaction!;
            annotaton.title = "Uber Driver"
            mapView.addAnnotation(annotaton);
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut() == true {
            dismiss(animated: true, completion: nil)
        } else {
            loginAlert(title: "LogOut Fail", message: "Please tye again Later")
        }
        
    }
    
    @IBAction func cancelRequest(_ sender: Any) {
        
    }
    
    private func loginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil)
    }

}

