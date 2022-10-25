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
    
    func addLocation(lat: String, lon: String) {
        
        info.location = Location(latitude: lat, longitude: lon)
                
        sendJson(info: info)
    }
    
    
    
    func sendJson(info: InfoData) {  //TODO: fix the func
        
        if 200 == 200 {
            let users = getFromDatabase()
            print(users)
            
        } else {
            
            let dataJson: [String : String] = [
                "device ID": "\(info.deviceID)",
                "device Name": info.deviceName,
                "OS": info.infoOS,
                "latitude": info.location?.latitude ?? "Unknown",
                "longitude": info.location?.longitude ?? "Unknown"
            ]
        
        addInfoToDB(info: dataJson)
        }
        /*

            let jsonData = try? JSONSerialization.data(withJSONObject: dataJson)
            
            let urlString = "https://gorest.co.in/public-api/products"
            guard let url = URL(string: urlString) else {
                addInfo(info: info)
                return }
            
            let token = "xxx"
            
            // POST request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No DATA")
                    return
                }
                
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print(responseJSON)
                } catch {
                    print(error)
                }
                
            }
            task.resume()
        }
         */
    }
}
