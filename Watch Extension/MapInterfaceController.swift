//
//  MapInterfaceController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/28/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import WatchKit
import Foundation
import MapKit


class MapInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    @IBOutlet var map: WKInterfaceMap!
    var locationManager = CLLocationManager()


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coordinateRegion = MKCoordinateRegion(center: (self.locationManager.location?.coordinate)!, span: coordinateSpan)
        
//        map.addAnnotation((self.locationManager.location?.coordinate)!, with: WKInterfaceMapPinColor.green)
        map.setRegion(coordinateRegion)
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
