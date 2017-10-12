//
//  Airport.swift
//  Airports
//
//  Created by Joep on 24-09-17.
//  Copyright © 2017 Joep. All rights reserved.
//

import Foundation
import MapKit

class Airport {
    
    //MARK: properties
    var name : String?
    var iso_country : String?
    var municipality: String?
    var icao : String?
    var location : CLLocationCoordinate2D!
    
    public func setLocation(long : Double, lat : Double) {
        let longitude : CLLocationDegrees = long
        let latitude : CLLocationDegrees = lat
        
        location = CLLocationCoordinate2DMake(latitude, longitude)
    }
}




