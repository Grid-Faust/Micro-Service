//
//  Server.swift
//  Micro-Service
//
//  Created by Дмитрий Емелин on 10.10.2022.
//

import Foundation
import CoreLocation
import UIKit

struct Response: Codable {
    let name: String
    let deviceID: String
    let deviceName : String
    let infoOS: String
    
    let latitude: String
    let longitude: String
    
}

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
    

    
    func sendJson(info: InfoData) {

        let dataJson: [String : AnyHashable] = [
            "device ID": "\(info.deviceID)",
            "device Name": info.deviceName,
            "OS": info.infoOS,
            "latitude": info.location?.latitude ?? "Unknown",
            "longitude": info.location?.longitude ?? "Unknown"
        ]

        let url = URL(string: "https://6357e28c2712d01e14125ebe.mockapi.io/users")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // insert json data to the request
        if isEmptyDatabase() == true {
            let jsonData = try? JSONSerialization.data(withJSONObject: dataJson, options: .fragmentsAllowed)
            request.httpBody = jsonData
        } else {
            let users = getFromDatabase()
            let jsonData = try? JSONSerialization.data(withJSONObject: users!, options: .fragmentsAllowed)
            request.httpBody = jsonData
        }
        

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            if let response = response as? HTTPURLResponse {
                print(response)
                
                if response.statusCode == 200 {
                    
                    let users = getFromDatabase()
                    
                    if users != nil {
                        DispatchQueue.main.async {
                            do {
                                let json = try JSONDecoder().decode(Response.self, from: data)
                                print("Success: \(json)")
                                 
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                    
                    do {
                        let json = try JSONDecoder().decode(Response.self, from: data)
                        print("Success: \(json)")
                         
                    } catch {
                        print("Error: \(error)")
                    }
                   
                } else {
                    addInfoToDB(info: dataJson)
                }
            }
            
            
            
        }.resume()
        
        
    }
}
