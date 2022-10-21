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
        
       // print(flag ? "DataManager - You don't have a Database": "DataManager - You have a Database")
        
        let db = try Connection("\(path)/Informations.db")
        let users = Table("usermac")
            
        let deviceID = Expression<String>("Device ID")
        let deviceName = Expression<String>("Device Name")
        let infoOS = Expression<String>("OS Version")
        let latitude = Expression<String>("Latitude")
        let longitude = Expression<String>("Longitude")

        let infoDeviceIDString = "\(info.deviceID)"
        
//        try db.run(users.insert(deviceID <- infoDeviceIDString,
//                                deviceName <- info.deviceName,
//                                infoOS <- info.infoOS)
//        try db.run(users.filter(_id).update(deviceName <- info.deviceName))
//        try db.run(users.filter(_id == 1).update(infoOS <- info.infoOS))
        
        if let lat = info.location?.latitude, let lon = info.location?.longitude {
            
            try db.run(users.insert(deviceID <- infoDeviceIDString,
                                    deviceName <- info.deviceName,
                                    infoOS <- info.infoOS,
                                    latitude <- lat,
                                    longitude <- lon))
        } else {
            try db.run(users.insert(deviceID <- infoDeviceIDString,
                                        deviceName <- info.deviceName,
                                        infoOS <- info.infoOS))
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

func deleteItemFromList(at startID: Int, before finishID: Int){

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
        //print(users.filter(listNumber == 1).exists)
//        let firstID = users[_id]
//        print("first ID - \(firstID)")
//        let range = firstID + deleteID
//        print("range - \(range)")
                
        // check parametrs
        try db.run(users.filter(_id >= startID && _id <= finishID).delete())
        
    } catch {
        print("DataMenager - Error(deleteItemFromList): \(error)")
    }
        
}
