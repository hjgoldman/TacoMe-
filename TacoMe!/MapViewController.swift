//
//  MapViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 3/20/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.


import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var tacoLocations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        self.populateMap()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "TacoAnnotation")
        annotationView.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: .infoDark)
        
        let tacoImage = UIImage(named: "taco_annotation.png")
        let tacoImageView = UIImageView(image: tacoImage)
        tacoImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        
        
        annotationView.addSubview(tacoImageView)
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let selectedLoc = view.annotation
        
        let lat = selectedLoc?.coordinate.latitude
        let lng = selectedLoc?.coordinate.longitude
        
        let url  = NSURL(string: "http://maps.apple.com/?q=\(lat!),\(lng!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) == true {
            UIApplication.shared.open(url! as URL)
            
        }
        
    }
    
    func populateMap() {
        
        for location in self.tacoLocations {
            
//            let annotation = MKPointAnnotation()
//            
//            annotation.title = location.name
//        
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude)
//            
//            self.mapView.addAnnotation(annotation)
//            
        }
        
    }
    
    
}
