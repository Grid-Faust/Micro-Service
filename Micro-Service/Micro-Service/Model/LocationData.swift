//
//  LocationData.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 10.10.2022.
//

import Foundation
import CoreLocation

class LocationData: CLLocationManager {
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        latitude = lat
        longitude = lon
    }
    
    func printLocation() {
        print("latitude = \(latitude), longitude = \(longitude)")
    }
}
