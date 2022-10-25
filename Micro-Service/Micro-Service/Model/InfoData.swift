//
//  InfoData.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 10.10.2022.
//

import Foundation
import UIKit

struct Location {
    var latitude: String
    var longitude: String
}

struct InfoData {
    
    private var versionOS = UIDevice.current.systemVersion
    private var nameOS = UIDevice.current.systemName
    
    var deviceID: UUID = UUID()
    var deviceName = UIDevice.current.name
    var infoOS: String {
        return "\(nameOS) \(versionOS)"
    }
    
    var location: Location?
    
}

enum JsonEnum : String {
    case deviceID = "device ID"
    case deviceName = "device Name"
    case OS = "OS"
    case location = "location"
    case lat = "latitude"
    case lon = "longitude"
}

//struct JsonData {
//    
//    private var versionOS = UIDevice.current.systemVersion
//    private var nameOS = UIDevice.current.systemName
//    
//    var data: [String : Any] = [
//    "device ID": "\(UUID())",
//    "device Name": UIDevice.current.name,
//    "OS": "\(nameOS) \(versionOS)",
//    "location": [["latitude": String,
//                 "longitude": String]]
//    ]
//    
//    init(lat: String, lon: String) {
//        data[JsonEnum.location.rawValue] = ["latitude" = lat,
//                                        "longitude" = lon ]
//    }
//}
