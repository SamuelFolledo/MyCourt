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

class HomeMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate { //mkMapViewDelegate for the annotation imagees
    
    let court1: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.735075, -74.070643)
        annotation.title = "Children Park And Basketball Court"
        annotation.subtitle = "125 Corbin Ave, Jersey City, NJ 07306"
        let courtType:Int = 1
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    let court2: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.725640, -74.052906)
        annotation.title = "Mary Benson Court"
        annotation.subtitle = "Mary Benson Park Jersey City, NJ 07302"
        let courtType:Int = 2
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    let court3: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.727958, -74.045550)
        annotation.title = "Hamilton Park"
        annotation.subtitle = "25 W Hamilton Pl, Jersey City, NJ 07302"
        let courtType:Int = 3
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    let court4: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.723135, -74.086528)
        annotation.title = "A-Court of Lincoln Park"
        annotation.subtitle = "Jersey City, NJ 07304"
        let courtType:Int = 2
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    let court5: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.725501, -74.082837)
        annotation.title = "B-Court of Lincoln Park"
        annotation.subtitle = "Jersey City, NJ 07304"
        let courtType:Int = 2
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    let court6: CustomPointAnnotation = {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(40.729347, -74.083398)
        annotation.title = "C-Court of Lincoln Park"
        annotation.subtitle = "Jersey City, NJ 07304"
        let courtType:Int = 3
        
        annotation.courtType = courtType
        annotation.imageName = annotation.getImageName(courtType: courtType)
        return annotation
    }()
    
    
    
    
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
       
        setupViews()
        
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" //AdMob //8mins
        adBannerView.rootViewController = self //AdMob //8min s
        adBannerView.load(GADRequest()) //AdMob //9mins
        
        mapView.delegate = self
        mapView.addAnnotation(court1)
        mapView.addAnnotation(court2)
        mapView.addAnnotation(court3)
        mapView.addAnnotation(court4)
        mapView.addAnnotation(court5)
        mapView.addAnnotation(court6)
        
        
        
        
        
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
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //3 //12mins
//        if let coord = manager.location?.coordinate { //3 //12mins
//            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude) //3 //12mins
//            userLocation = center //3 //23mins
//
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //3 //13mins how big you want the region to be
//            mapView.setRegion(region, animated: true) //3 //13mins set region
//
////            mapView.removeAnnotations(mapView.annotations) //3 //16mins removes all the annotations everytime we change our location
////            //13mins now the map shows our location on the mapView. Now we need an annotation to show exactly where our user is and add it to our map
//////            let annotation = MKPointAnnotation() //3 //14mins
////            var annotation = MKMarkerAnnotationView()
//
////            annotation.coordinateSpace = center //3 //15mins put it on the center
////            annotation.title = "Your location" //3 //15mins
////
////
////            mapView.addAnnotation(annotation) //3 //16mins now time to start saving our location to firebase
//        }
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) { //if annotation is not our custom class
            return nil
        }
        
        let reuseId = "courtAnnotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        } else {
            anView?.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named: cpa.imageName)
        
        return anView
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    /*
    @objc func directions(_ sender: Any) {
        //UIApplication.shared.open(URL(string: "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        
    }
 */
    
    
    
    
    @IBAction func profileButtonTapped() {
        self.performSegue(withIdentifier: "mapToUserSegue", sender: nil)
    }
    

    @IBAction func chatButtonTapped(_ sender: Any) {
        print("Chat tapped")
        let vc = MessagesController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    

}



class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String = ""
    var courtType: Int? //1 is home, 2 is away, 3 is regular court
    
    func getImageName (courtType: Int) -> String {
        var imgName:String?
        switch courtType {
        case 1:
            imgName = "basketballCourt1"
        case 2:
            imgName = "basketballCourt2"
        case 3:
            imgName = "basketballCourt3"
        default:
            imgName = "basketballCourt3"
        }
        return imgName!
    }
    
}
