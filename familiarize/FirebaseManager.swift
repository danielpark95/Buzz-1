//
//  FirebaseManager.swift
//  familiarize
//
//  Created by Alex Oh on 7/28/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FirebaseManager {
    
    // MARK: - Shared Instance
    static let storageRef: StorageReference = {
        let storage = Storage.storage()
        return storage.reference()
    }()
    
    static let databaseRef: DatabaseReference = {
        let database = Database.database()
        return database.reference()
    }()
    
    static func generateUniqueID() -> UInt64 {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)%100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let milliseconds = calendar.component(.nanosecond, from: date)/100
        let randomNumber = Int(arc4random())%1000
        
        let uniqueIDString = String(format: "%i%i%i%i%i%i%i%i", arguments: [year,
                                                                            month,
                                                                            day,
                                                                            hour,
                                                                            minutes,
                                                                            seconds,
                                                                            milliseconds,
                                                                            randomNumber])
        
        return UInt64(uniqueIDString)!
    }

    
    static func uploadCard(_ cardJSON: JSON, withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        let userID = UIDevice.current.identifierForVendor!.uuidString
        for (key,value):(String, JSON) in cardJSON {
            databaseRef.child("cards").child(uniqueIDString).child(key).setValue(value.string)
        }
        databaseRef.child("users").child(userID).childByAutoId().setValue(uniqueIDString)
    }

    static func uploadImage(_ socialMediaProfileImage: SocialMediaProfileImage, completionHandler: @escaping (String) -> Void) {
        let profileImage = UIImagePNGRepresentation(socialMediaProfileImage.profileImage!)
        
        // Create a reference to the file you want to upload
        let profileImageRef = storageRef.child("\(UIDevice.current.identifierForVendor!.uuidString)/\(UUID().uuidString)")

        let _ = profileImageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            completionHandler((metadata.downloadURL()?.absoluteString)!)
        }
    }
    
    static func getCard(withUniqueID uniqueID: UInt64, completionHandler: @escaping (JSON) -> Void) {
        let uniqueIDString = String(uniqueID)
        databaseRef.child("cards").child(uniqueIDString).observeSingleEvent(of: .value, with: { (snapshot) in
            var cardJSON:JSON = [:]
            for childSnap in snapshot.children {
                let snap = childSnap as! DataSnapshot
                cardJSON[snap.key].string = snap.value as! String
            }
            completionHandler(cardJSON)

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
