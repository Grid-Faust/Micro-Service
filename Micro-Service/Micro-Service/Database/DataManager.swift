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
        copyDatabaseIfNeeded(sourcePath: Bundle.main.path(forResource: "Informations", ofType: "db")!)
        let db = try Connection("\(path)/Informations.db")
        let users = Table("usermac")
        
        let deviceID = Expression<String>("Device ID")
        let deviceName = Expression<String>("Device Name")
        let infoOS = Expression<String>("OS Version")
        let location = Expression<[String]>("Location")
        
        try db.run(users.insert(infoOS <- info.infoOS))
        
        
    } catch {
        print(error)
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
      print("error during file copy: \(error)")
        return false
    }
}
