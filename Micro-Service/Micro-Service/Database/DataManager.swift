//
//  DataManager.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 12.10.2022.
//

import Foundation
import SQLite


let deviceID = Expression<String>("Device ID")
let deviceName = Expression<String>("Device Name")
let infoOS = Expression<String>("OS Version")
let latitude = Expression<String>("Latitude")
let longitude = Expression<String>("Longitude")

func addInfoToDB(info: [String : Any]) {
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        let bundlePath = Bundle.main.path(forResource: "Informations", ofType: "db")!
        let flag = copyDatabaseIfNeeded(sourcePath: bundlePath)
        
       // print(flag ? "DataManager - You don't have a Database": "DataManager - You have a Database")
        
        let db = try Connection("\(path)/Informations.db")
        let users = Table("usermac")
            
        
        
        let data = Expression<Blob>("Data")
        

        let infoDeviceIDString = "\(info[JsonEnum.deviceID.rawValue]!)"
        let deviceNameString = "\(info[JsonEnum.deviceName.rawValue]!)"
        let infoOSString = "\(info[JsonEnum.OS.rawValue]!)"
        let latitudeString = "\(info[JsonEnum.lat.rawValue]!)"
        let longitudeString = "\(info[JsonEnum.lon.rawValue]!)"
        
        
        
        try db.run(users.insert(deviceID <- infoDeviceIDString,
                               deviceName <- deviceNameString,
                               infoOS <- infoOSString,
                               latitude <- latitudeString,
                               longitude <- longitudeString))
        
//        if let loc = info[JsonEnum.location.rawValue], let lon = info.location?.longitude {
//
//            try db.run(users.insert(deviceID <- infoDeviceIDString,
//                                    deviceName <- info.deviceName,
//                                    infoOS <- info.infoOS,
//                                    latitude <- lat,
//                                    longitude <- lon))
//        } else {
//            try db.run(users.insert(deviceID <- infoDeviceIDString,
//                                        deviceName <- info.deviceName,
//                                        infoOS <- info.infoOS))
//            }
        
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

func getFromDatabase() -> [[String: String]]? {
    
    var jsonArray = [[String : String]]()
    
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        let bundlePath = Bundle.main.path(forResource: "Informations", ofType: "db")!
                
        let db = try Connection("\(path)/Informations.db")
        let users = Table("usermac")
        
        let id = Expression<Int>("id")
        
        let table = users.order(id.desc)
        
        for item in try db.prepare(table) {
                        
            let idValue = item[id]
            let deviceIDValue = item[deviceID]
            let deviceNameValue = item[deviceName]
            let infoOSValue = item[infoOS]
            let latitudeValue = item[latitude]
            let longitudeValue = item[longitude]
            
            // Create object
            let dataJson: [String : String] = [
                "device ID": deviceIDValue,
                "device Name": deviceNameValue,
                "OS": infoOSValue,
                "latitude": latitudeValue,
                "longitude": longitudeValue
            ]
            
            // Add object to an array
            jsonArray.append(dataJson)
            
            deleteItemFromList(at: idValue)
        }
        
    } catch {
        print("DataManager - Error(getFromDatabase): \(error.localizedDescription)")
    }
    return jsonArray
}

func deleteItemFromList(at startID: Int){

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
        try db.run(users.filter(_id == startID).delete())
        
    } catch {
        print("DataMenager - Error(deleteItemFromList): \(error)")
    }
        
}
