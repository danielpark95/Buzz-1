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
    
    static func uploadCard(_ userProfileJSON: JSON, withUniqueID uniqueID: UInt64) {
        
        let uniqueIDString = String(uniqueID)
        let userID = UIDevice.current.identifierForVendor!.uuidString
        for (key,value):(String, JSON) in userProfileJSON {
            databaseRef.child("cards").child(uniqueIDString).child(key).setValue(value.string)
        }
        databaseRef.child("users").child(userID).childByAutoId().setValue(uniqueID)
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
    
}
