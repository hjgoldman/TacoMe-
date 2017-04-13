//
//  LocationAnnotaion.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/13/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation
import UIKit
import HDAugmentedReality
import MapKit

class LocationAnnotation :ARAnnotation {
    
    var tacoLocation :TacoLocation!
    
    init(tacoLocation :TacoLocation) {
        
        super.init()
        
        self.title = tacoLocation.name
        self.location = CLLocation(latitude: tacoLocation.locationLat!, longitude: tacoLocation.locationLng!)
        self.tacoLocation = tacoLocation
    }
    
    
    
}
