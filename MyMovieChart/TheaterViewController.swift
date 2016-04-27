//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by 김승현 on 2016. 4. 27..
//  Copyright © 2016년 aivesoft. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController : UIViewController {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var navbar: UINavigationItem!
    
    var param : NSDictionary?
    
    override func viewDidLoad() {
        navbar.title = param?["movieNm"] as? String
        
        //let lat = (param?["위도"] as !NSString).doubleValue
        //let lng = (param?["경도"] as !NSString).doubleValue
        let lat = 37.566535
        let lng = 126.97796919999996
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        let regionRadius: CLLocationDistance = 5000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        
        self.map.setRegion(coordinateRegion, animated: true)
        
        let point = MKPointAnnotation()
        point.coordinate = location
        
        self.map.addAnnotation(point)
    }
}
