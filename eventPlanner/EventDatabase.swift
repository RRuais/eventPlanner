//
//  EventDatabase.swift
//  eventPlanner
//
//  Created by Rich Ruais on 7/25/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation
import Firebase

class EventDatabase {
    
    func saveEvent(newEvent: Event) {
        let newEvent = newEvent
        let date = Date()
        let imageStorageRef = "\(date)" + "\(newEvent.name)"
        let storage = FIRStorage.storage().reference().child(String(imageStorageRef))
        let uploadData = UIImagePNGRepresentation(newEvent.image!)
        
        storage.put(uploadData!, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                print(profileImageUrl)
                var eventToSave = [String:String]()
                print(newEvent)
                eventToSave = ["name": String(newEvent.name), "address": String(newEvent.address), "price": String(newEvent.price), "dateTime": String(newEvent.dateTime) , "imageUrl": profileImageUrl]
                let ref = FIRDatabase.database().reference(withPath: "Events").child(String(describing: date))
                ref.setValue(eventToSave) { (error, ref) -> Void in
                    print(error.debugDescription)
                    print(error?.localizedDescription as Any)
                }
            }
        })
    }
    
    func retrieveEvents() {
        var currentEvents = [[String: String]]()
        
        FIRDatabase.database().reference(withPath: "Events").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for (key, value) in dictionary {
                    var object = value as! [String: Any]
                    let name = object["name"] as! String
                    let address = object["address"] as! String
                    let price = object["price"] as! String
                    let dateTime = object["dateTime"] as! String
                    let imageUrl = object["imageUrl"] as! String
                   
                    let newEvent: [String: String] = ["name": name, "address": address, "price": price, "dateTime": dateTime, "imageUrl": imageUrl, "title": String(key)]
                    currentEvents.append(newEvent)
                }
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(currentEvents, forKey: "events")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func deleteEvent(title: String) {
        let ref = FIRDatabase.database().reference(withPath: "Events")
            ref.child(title).removeValue { (error, ref) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
            print("Successfully Deleted Score")
    }

}
