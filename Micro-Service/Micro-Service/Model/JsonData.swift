//
//  JsonData.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 21.10.2022.
//

import Foundation

let dataJson: [String : Any] = [
    "device ID": info.deviceID,
    "device Name": info.deviceName,
    "OS": info.infoOS,
    "location": [["latitude": info.location?.latitude,
                 "longitude": info.location?.longitude]]
]
