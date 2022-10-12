//
//  Server.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 10.10.2022.
//

import Foundation
import CoreLocation
import UIKit

class Server {
    
    var info = InfoData()
    
    func printInfo() {
        let info = InfoData()
        print(info.deviceID)
        print(info.deviceName)
        print(info.infoOS)
    }
    
    func addLocation(lat: Double, lon: Double) {
        
        info.location?.latitude = lat
        info.location?.longitude = lon
        
        addInfo(info: info)
    }
}
