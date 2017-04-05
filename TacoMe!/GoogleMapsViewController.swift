//
//  GoogleMapsViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/5/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var tacoLocations = [TacoLocation]()
    var tacoLocationPlace_id :String!
    
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
            
            marker.userData = location
            
            marker.icon = UIImage(named: "taco_marker.png")
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)

            marker.map = mapView
            
        }
        
        // enable my location dot
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
    }

    
    //MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
        
        customWindow.nameLabel.text = marker.title
        customWindow.addressLabel.text = marker.snippet
//        customWindow.moreInfoButton.addTarget(self, action: #selector(moreInfoButtonPressed(_:)), for: .touchUpInside)
        
        return customWindow
    }

    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let tacoLocation = marker.userData as! TacoLocation
        
        self.tacoLocationPlace_id = tacoLocation.place_id
        
        self.performSegue(withIdentifier: "MoreInfoSegue", sender: self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MoreInfoSegue" {
            
            let moreInfoVC = segue.destination as! MoreInfoViewController
            moreInfoVC.tacoLocationPlace_id = self.tacoLocationPlace_id
            
        }
        
    }
    

}
