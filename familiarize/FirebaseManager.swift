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
    
    // MARK: - Shared Instance - Singleton
    static let storageRef: StorageReference = {
        let storage = Storage.storage()
        return storage.reference()
    }()
    
    static let databaseRef: DatabaseReference = {
        let database = Database.database()
        return database.reference()
    }()
    
    static func generateUniqueID() -> UInt64 {
        return UInt64(arc4random()) + (UInt64(arc4random()) << 32)
//        let timeIntervalSince1970InMilliseconds = UInt64(Date().timeIntervalSince1970 * 1000.0)
//        let randomNumber = Int(arc4random())%10000
//        let uniqueIDString = String(format: "%llu%i", arguments: [timeIntervalSince1970InMilliseconds, randomNumber])
//        return UInt64(uniqueIDString)!
    }
    
    static func uploadCard(_ cardJSON: JSON, withUniqueID uniqueID: UInt64) -> Bool{
        let uniqueIDString = String(uniqueID)
        let userID = UIDevice.current.identifierForVendor!.uuidString
        databaseRef.child("users").child(userID).childByAutoId().setValue(uniqueIDString)
        for (key,value):(String, JSON) in cardJSON {
            databaseRef.child("cards").child(uniqueIDString).child(key).setValue(value.string)
        }
        // TODO: Check for when the uniqueIDString is already in the database. Then return false and create a new unique id.
        return true
    }
    
    static func updateCard(_ newCardJSON: JSON, withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        for (key,value):(String, JSON) in newCardJSON {
            databaseRef.child("cards").child(uniqueIDString).child(key).setValue(value.string)
        }
    }

    static func uploadImage(_ socialMediaProfileImage: SocialMediaProfileImage, completionHandler: @escaping (String) -> Void) {
        let profileImage = UIImageJPEGRepresentation(socialMediaProfileImage.profileImage!, 1.0)
        
        // Create a reference to the file you want to upload
        let profileImageRef = storageRef.child("\(UIDevice.current.identifierForVendor!.uuidString)/\(UUID().uuidString)")

        _ = profileImageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
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
