//
//  BasketballCourts.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/26/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import MapKit
import AddressBook

class BasketballCourts: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    var imageName: String = ""
    var courtType: Int? //1 is home, 2 is away, 3 is regular court
    
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D, imageName: String, courtType: Int) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        self.imageName = imageName
        self.courtType = courtType
        
        super.init()
    }
    
    var subtitle: String? { //subtitle will be the locationName
        return locationName
    }
    
    
    
    
    
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

//class CustomPointAnnotation: MKPointAnnotation {
//    var imageName: String = ""
//    var courtType: Int? //1 is home, 2 is away, 3 is regular court
//
//    func getImageName (courtType: Int) -> String {
//        var imgName:String?
//        switch courtType {
//        case 1:
//            imgName = "basketballCourt1"
//        case 2:
//            imgName = "basketballCourt2"
//        case 3:
//            imgName = "basketballCourt3"
//        default:
//            imgName = "basketballCourt3"
//        }
//        return imgName!
//    }
//
//}
