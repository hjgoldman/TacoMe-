//
//  GoogleMapsViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/5/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var tacoLocations = [TacoLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let lat = self.locationManager.location?.coordinate.latitude
        let lng = self.locationManager.location?.coordinate.longitude
        
        
        // creates the map and zooms the current user location, at a 6.0 zoom
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lng!, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        for location in self.tacoLocations {
            
            let marker = GMSMarker()
            
            let lat = location.locationLat
            let lng = location.locationLng
            
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            marker.title = location.name
            marker.snippet = location.vicinity
            
            marker.icon = UIImage(named: "taco_marker.png")
            marker.map = mapView
            
        }
        
        // enable my location dot
        mapView.isMyLocationEnabled = true
        
    }
    
    
    
    

}
