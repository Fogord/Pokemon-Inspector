//
//  Server.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 09.01.2019.
//  Copyright © 2019 Artem Yerko. All rights reserved.
//

import UIKit

import Parse
import Alamofire

class Server {
    
    var isTryToReciveAll: Int = 0
    
    let headers = [
        "Cookie":"__cfduid=dbb6498331c771bea9f3826fcd57f6a6f1546264025",
    ]
    
    init() {
        let parseConfig = ParseClientConfiguration {
            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "I0AugvNyOijYV23GyVfkNLKPqxrGuSa9dMDHe3C3"
            $0.clientKey = "dUzpHTXsBZIYfMt2tvC9aaFoTCTfeuzELpYRMqkW"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: parseConfig)
    }
    
    func checkInternetAvailable() -> Bool {
        return true
    }
    
    func getAll() {
        if checkInternetAvailable() {
            print("Internet is available ")
        }
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/", method: .get, headers: headers)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let result = response.result.value {
                        //let JSON = result as! NSDictionary
                        self.isTryToReciveAll = 200 //JSON["count"] as! Int
                        self.getById(self.isTryToReciveAll)
                    }
                }
                else {
                    print("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    func getById(_ count: Int) {
        for i in 1...count {
            Alamofire.request("https://pokeapi.co/api/v2/pokemon/\(i)/", method: .get, headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    if (response.result.error == nil) {
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            
                            let query = PFQuery(className: tableNme)
                            query.fromLocalDatastore()
                            query.whereKey("id", equalTo: JSON["id"])
                            
                            do {
                                let objectsToDisplay = try query.findObjects()
                                if objectsToDisplay.count == 0 {
                                    let newObject = PFObject(className: tableNme)
                                    
                                    newObject["id"]     = (JSON["id"] as! Int)
                                    newObject["name"]   = (JSON["name"] as! String)
                                    newObject["type"]   = types.randomElement()
                                    newObject["weight"] = (JSON["weight"] as! Int)
                                    newObject["height"] = (JSON["height"] as! Int)
                                    newObject["image"]  = ((JSON["sprites"] as! NSDictionary)["front_default"] as! String)
                                    
                                    do {
                                        try newObject.pin()
                                    } catch {
                                        print("Unexpected error pinned: \(error).")
                                    }
                                }
                               
                            } catch {
                                print("Unexpected error: find \(error).")
                            }
                        }
                        
                        self.isTryToReciveAll -= 1;
                        print(self.isTryToReciveAll)
                        if self.isTryToReciveAll == 0 {
                            NotificationCenter.default.post(name: NotificatiomNames.dataIsSync, object: nil)
                        } else {
                            NotificationCenter.default.post(name: NotificatiomNames.dataWasGot, object: nil, userInfo: ["counter":(String(count - self.isTryToReciveAll) + " / " + String(count))])
                        }
                    }
                    else {
                        print("HTTP Request failed id: \(i): \(response.result.error)")
                    }
            }
        }
    }
    

}
