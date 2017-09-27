//
//  DriverVC.swift
//  Driver Application
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import MapKit
class DriverVC: UIViewController, CLLocationManagerDelegate, UberController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelRequestButton: UIButton!
    private var locationManager = CLLocationManager();
    private var userLoaction: CLLocationCoordinate2D?;
    private var riderLocation: CLLocationCoordinate2D?;
    
    var isDriverCancelled = false
    var isDriverAccepted = false
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        UberHandler.Instances.delegate = self
        UberHandler.Instances.observeMessageForDriver()
    }
    
    
    func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    }
    
    func updateDriverLocation() {
        UberHandler.Instances.updateDriverLocation(lat: (userLoaction?.latitude)!, long: (userLoaction?.longitude)!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            userLoaction = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLoaction!, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
            
            //remove the preious annotation
            mapView.removeAnnotations(mapView.annotations)
            
            if riderLocation != nil {
                let annotation = MKPointAnnotation()
                annotation.title = "Riders Location"
                annotation.coordinate = riderLocation!
                mapView.addAnnotation(annotation)
            }
            let annotaton = MKPointAnnotation()
            annotaton.coordinate = userLoaction!;
            annotaton.title = "Uber Driver"
            mapView.addAnnotation(annotaton);
        }
    }
    
    func aceptUber(long: Double, lat: Double){
        if !isDriverAccepted {
            uberRequest(title: "Uber Request", message: "You have a new request from the Location: Long: \(long), & Lat: \(lat)", isAlive: true)
        } else {
            isDriverAccepted = false
        }
    }
    
    func riderCancelledUber() {
        if !isDriverCancelled {
            UberHandler.Instances.driverCancelledUber()
            self.isDriverAccepted = false
            self.cancelRequestButton.isHidden = true
            uberRequest(title: "Uber Cancelled", message: "Rider has cancelled Uber", isAlive: false)
        }
    }
    
    func driverCancelledUber() {
        isDriverAccepted = false
        cancelRequestButton.isHidden = true
        
        timer.invalidate()
    }
    
    @IBAction func cancelRequest(_ sender: Any) {
        if isDriverAccepted {
            UberHandler.Instances.driverCancelledUber()
            isDriverAccepted = true
            cancelRequestButton.isEnabled = false
            
            timer.invalidate()
            
        }
    }
    
    func updateRiderLocation(lati: Double, long: Double) {
        riderLocation = CLLocationCoordinate2D.init(latitude: lati, longitude: long)
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut() == true {
            dismiss(animated: true, completion: nil)
        } else {
            uberRequest(title: "Login Fail!", message: "Please try again Later", isAlive: false)
        }
    }
    
    private func uberRequest(title: String, message: String, isAlive: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                self.isDriverAccepted = true
                self.cancelRequestButton.isHidden = false
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(DriverVC.updateDriverLocation), userInfo: nil, repeats: true)
                
                UberHandler.Instances.uberAccepted(lat: Double((self.userLoaction?.latitude)!), long: Double((self.userLoaction?.longitude)!))
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(accept)
            alert.addAction(cancel)
        } else {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
