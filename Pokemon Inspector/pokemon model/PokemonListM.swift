//
//  PokemonListM.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 13.12.2018.
//  Copyright © 2018 Artem Yerko. All rights reserved.
//

import UIKit
import NotificationCenter

import Parse
import Alamofire

class PokemonListM {
    struct PokemonM {
        var id: Int
        var name: String
        var imageUrl: String
        var type: String
        var weight: Int
        var height: Int
    }
    
    var list: [PokemonM]?
    
    init(){
        list = [];
    }
    
    func getAllItems(){
        let query = PFQuery(className: tableNme)
        query.addAscendingOrder("type")
        query.fromLocalDatastore()
        
        do {
            let objectsToDisplay = try query.findObjects()
            
            for obj in objectsToDisplay  {
                self.list?.append(PokemonM(
                    id:       obj["id"] as! Int,
                    name:     obj["name"] as! String,
                    imageUrl: obj["image"] as! String,
                    type:     obj["type"] as! String,
                    weight:   obj["weight"] as! Int,
                    height:   obj["height"] as! Int))
            }
            NotificationCenter.default.post(name: NotificatiomNames.dataIsReceived, object: nil)
        } catch {
            print("find in localstorage went wrong")
        }
    }

//    func getItem(_ indexItem: Int) -> PokemonM? {
//        var result: PokemonM?
//        let query = PFQuery(className: tableNme)
//        query.fromLocalDatastore()
//        query.whereKey("id", contains: String(indexItem))
//        query.findObjectsInBackground { (objects, error) in
//            let objectsToDisplay = objects ?? [PFObject]()
//
//            for obj in objectsToDisplay  {
//                result = PokemonM(
//                    id:       obj["id"] as! Int,
//                    name:     obj["name"] as! String,
//                    image:    obj["image"] as! String,
//                    species:  "",//obj["species"] as! String,
//                    weight:   obj["weight"] as! Int,
//                    height:   obj["height"] as! Int)
//            }
//        }
//
//        return result ?? nil
//    }
}

//func get() {
//    if checkInternetAvailable() {
//        print("Internet is available ")
//    }
//    Alamofire.request("https://pokeapi.co/api/v2/pokemon/", method: .get, headers: headers)
//        .validate(statusCode: 200..<500)
//        .responseJSON { response in
//            if (response.result.error == nil) {
//                if let result = response.result.value {
//                    let JSON = result as! NSDictionary
//                    self.isTryToReciveAll = 20 //JSON["count"] as! Int
//                    self.getById(self.isTryToReciveAll)
//                }
//            }
//            else {
//                print("HTTP Request failed: \(response.result.error)")
//            }
//    }
//}
//
//func getById(_ count: Int) {
//    for i in 1...count {
//        Alamofire.request("https://pokeapi.co/api/v2/pokemon/\(i)/", method: .get, headers: headers)
//            .validate(statusCode: 200..<500)
//            .responseJSON { response in
//                if (response.result.error == nil) {
//                    if let result = response.result.value {
//                        let JSON = result as! NSDictionary
//
//                        let query = PFQuery(className: self.tableNme)
//                        query.fromLocalDatastore()
//                        query.whereKey("id", equalTo: JSON["id"])
//                        query.findObjectsInBackground { (objects, error) in
//                            let objectsToDisplay = objects ?? [PFObject]()
//                            if objectsToDisplay.count > 0 {
//                                return
//                            } else {
//                                let newObject = PFObject(className: self.tableNme)
//                                
//                                newObject["id"]          = (JSON["id"] as! Int)
//                                newObject["name"]        = (JSON["name"] as! String)
//
//                                let urlString = ((JSON["sprites"]as! NSDictionary)["front_default"] as! String)
//                                let url = NSURL(string: urlString)! as URL
//                                if let imageData: NSData = NSData(contentsOf: url) {
//                                    newObject["image"] = String(data: imageData as Data, encoding: .utf8) ?? ""
//                                }
//
//                                newObject["species"]     = "" //(JSON["species"] as! String)
//                                newObject["weight"]      = (JSON["weight"] as! Int)
//                                newObject["height"]      = (JSON["height"] as! Int)
//
//                                newObject.pinInBackground{ (success, error) in
//                                    if success {
//                                        print(self.isTryToReciveAll)
//                                        self.isTryToReciveAll -= 1;
//                                        if self.isTryToReciveAll == 0 {
//                                            NotificationCenter.default.post(name: NotificatiomNames.dataIsLoaded, object: nil)
//                                        }
//                                    } else {
//                                        print(error!.localizedDescription)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else {
//                    print("HTTP Request failed id: \(i): \(response.result.error)")
//                }
//        }
//    }
//}
