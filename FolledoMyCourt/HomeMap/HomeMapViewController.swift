//
//  HomeMapViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds

class HomeMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    
    //var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var adBannerView: GADBannerView!
    
//++++++++++++++++++++++ viewDidLoad ++++++++++++++++++++++
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .purple
        self.navigationController?.isNavigationBarHidden = true
        //navigationItem.title = "Map"
       
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" //AdMob //8mins
        adBannerView.rootViewController = self //AdMob //8min s
        adBannerView.load(GADRequest()) //AdMob //9mins
        
        
        setupViews()
        
        
        
        //let span = MKCoordinateSpanMake(0.05, 0.05)
        //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        //mapView.setRegion(region, animated: true)
        
        //let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        //let pinObject = MKPointAnnotation()
        
        //pinObject.coordinate = pinLocation
        //pinObject.title = "SM City East Ortigas"
        //pinObject.subtitle = "Ortigas Ave Ext, Pasig, Metro Manila, Philippines"
        
        //mapView.addAnnotation(pinObject)

        
    }
    
    private func setupViews() {
        //setupProfileButton()
        setupLocationManager()
        
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self //3 //8mins
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //3 //8mins
        locationManager.requestWhenInUseAuthorization() //3 //8mins
        locationManager.startUpdatingLocation() //3 //8mins
    }
    
//
//    @objc func standard(_ sender: Any) {
//        mapView.mapType = MKMapType.standard
//    }
//
//    @objc func satellite(_ sender: Any) {
//        mapView.mapType = MKMapType.satellite
//    }
//
//    @objc func hybrid(_ sender: Any) {
//        mapView.mapType = MKMapType.hybrid
//    }
//
//    @objc func locateMe(_ sender: Any) {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//        mapView.showsUserLocation = true
//    }
    
//didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //3 //12mins
        if let coord = manager.location?.coordinate { //3 //12mins
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude) //3 //12mins
            userLocation = center //3 //23mins
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //3 //13mins how big you want the region to be
            mapView.setRegion(region, animated: true) //3 //13mins set region
            
            mapView.removeAnnotations(mapView.annotations) //3 //16mins removes all the annotations everytime we change our location
            //13mins now the map shows our location on the mapView. Now we need an annotation to show exactly where our user is and add it to our map
            let annotation = MKPointAnnotation() //3 //14mins
            annotation.coordinate = center //3 //15mins put it on the center
            annotation.title = "Your location" //3 //15mins
            mapView.addAnnotation(annotation) //3 //16mins now time to start saving our location to firebase
        
        }
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    @objc func directions(_ sender: Any) {
        //UIApplication.shared.open(URL(string: "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        
    }
 */
    
    
    
    
    @IBAction func profileButtonTapped() {
        self.performSegue(withIdentifier: "mapToUserSegue", sender: nil)
    }
    

    
    

}

