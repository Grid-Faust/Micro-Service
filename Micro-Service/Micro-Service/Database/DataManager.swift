//
//  DataManager.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 12.10.2022.
//

import Foundation
import SQLite

func addInfo(info: InfoData) {
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        let bundlePath = Bundle.main.path(forResource: "Informations", ofType: "db")!
        let flag = copyDatabaseIfNeeded(sourcePath: bundlePath)
        
        print(flag ? "DataManager - You don't have a Database": "DataManager - You have a Database")
        
        let db = try Connection("\(path)/Informations.db")
        let users = Table("usermac")
        let _id = Expression<Int>("id")
            
        let deviceID = Expression<String>("Device ID")
        let deviceName = Expression<String>("Device Name")
        let infoOS = Expression<String>("OS Version")
        let latitude = Expression<String>("Latitude")
        let longitude = Expression<String>("Longitude")

        let infoDeviceIDString = "\(info.deviceID)"
        
        if flag {
            try db.run(users.insert(deviceID <- infoDeviceIDString))
        }
        
        try db.run(users.filter(_id == 1).update(deviceID <- infoDeviceIDString))
        try db.run(users.filter(_id == 1).update(deviceName <- info.deviceName))
        try db.run(users.filter(_id == 1).update(infoOS <- info.infoOS))
        
        if let lat = info.location?.latitude, let lon = info.location?.longitude {
            try db.run(users.filter(_id == 1).update(latitude <- lat))
            try db.run(users.filter(_id == 1).update(longitude <- lon))
        }
        
    } catch {
        print("DataMenager - Error(AddInfo): \(error)")
    }
}

func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let destinationPath = documents + "/Informations.db"
    let exists = FileManager.default.fileExists(atPath: destinationPath)
    guard !exists else { return false }
    do {
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
        return true
    } catch {
      print("DataMenager - Error(copyDatabaseIfNeeded): \(error)")
        return false
    }
}
