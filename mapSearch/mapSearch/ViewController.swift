//
//  ViewController.swift
//  mapSearch
//
//  Created by Ram Yadav on 7/30/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func searchBar(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        present(searchController, animated: true, completion: nil)
    }
    
    
//    @IBAction func myLocation(_ sender: Any) {
//        self.myMap.showsUserLocation = true;
//        self.myMap.setUserTrackingMode(.follow, animated: true)
//    }
//    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicators
        let ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        ActivityIndicator.center = self.view.center
        ActivityIndicator.startAnimating()
        
        self.view.addSubview(ActivityIndicator)
        
        
        //hidden seach bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create a search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text;
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        ActivityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        activeSearch.start { (result, error) in
            if error != nil {
                print("ERROR OCCURED!")
            } else {
                //remove original annotation
                let annotations = self.myMap.annotations
                self.myMap.removeAnnotations(annotations)
                
                //Getting Data
                let latitue = result?.boundingRegion.center.latitude
                let longitude = result?.boundingRegion.center.longitude
                
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitue!, longitude: longitude!)
                self.myMap.addAnnotation(annotation)
                
                //zooming the place
                let location = CLLocationCoordinate2DMake(latitue!, longitude!)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake(location, span)
                self.myMap.setRegion(region, animated: true)
                
                
                
            }
        }
        
    }
}

