//
//  TacoLocation.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 3/20/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation
import MapKit

class TacoLocation {
    
    var coordinate :CLLocation!
    var name :String!
    var address :[String]!
    var distance :Double!
    var rating :Double!
    var price :String!
    var isClosed :Bool!
    var yelpUrl :String!
}
