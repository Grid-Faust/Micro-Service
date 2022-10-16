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
