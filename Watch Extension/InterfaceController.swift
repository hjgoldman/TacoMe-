//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Hayden Goldman on 4/27/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import WatchKit
import Foundation
import MapKit


class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    @IBOutlet var group: WKInterfaceGroup!
    var locationManager = CLLocationManager()


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func tacoButton() {
        
        print("taco pressed!")

        let action1 = WKAlertAction(title: "🌮", style: .default) {
        
            print("ok")
        }
        let cancelAction = WKAlertAction(title: "🚫", style: .cancel) {}
        
        presentAlert(withTitle: "Taco Found!", message: "", preferredStyle: .actionSheet, actions: [action1,cancelAction])
        
    }

}
