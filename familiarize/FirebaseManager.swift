//
//  FirebaseManager.swift
//  familiarize
//
//  Created by Alex Oh on 7/28/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import Firebase

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
    
    /* Attempt at trying to find unique id.
    static func generateUniqueID(completionHandler: @escaping (UInt64) -> Void) {
        let asyncDispatchGroup = DispatchGroup()
        while true {
            asyncDispatchGroup.enter()
            let uniqueID = UInt64(arc4random()) + (UInt64(arc4random()) << 32)
            let uniqueIDString = String(uniqueID)
            var isTruelyUnique = false
            databaseRef.child("cards").child(uniqueIDString).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.value == nil {
                    isTruelyUnique = true
                    asyncDispatchGroup.leave()
                }
            })
            asyncDispatchGroup.notify(queue: DispatchQueue.main, execute: {
                if isTruelyUnique {
                    completionHandler(uniqueID)
                    return
                }
            })
        }
    }
 */
    
    static func generateUniqueID() -> UInt64 {
        return UInt64(arc4random()) + (UInt64(arc4random()) << 32)
    }
    
    static func uploadCard(_ userCard: [String:[String]], withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        let userID = UIDevice.current.identifierForVendor!.uuidString
        databaseRef.child("users").child(userID).childByAutoId().setValue(uniqueIDString)
        for (eachKey, manyValues) in userCard {
            for eachValue in manyValues{
                databaseRef.child("cards").child(uniqueIDString).child(eachKey).childByAutoId().setValue(eachValue)
            }
        }
        // TODO: Check for when the uniqueIDString is already in the database. Then return false and create a new unique id.
    }
    
    static func updateCard(_ userCard: [String:[String]], withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        databaseRef.child("cards").child(uniqueIDString).removeValue()
        for (eachKey, manyValues) in userCard {
            for eachValue in manyValues {
                databaseRef.child("cards").child(uniqueIDString).child(eachKey).childByAutoId().setValue(eachValue)
            }
        }
    }
    
    static func updateCard(_ profileImageInfo: [String:String], withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        for (key,value):(String, String) in profileImageInfo {
            databaseRef.child("cards").child(uniqueIDString).child(key).childByAutoId().setValue(value)
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
    
    static func getCard(withUniqueID uniqueID: UInt64, completionHandler: @escaping ([String:[String]]) -> Void) {
        let uniqueIDString = String(uniqueID)
        databaseRef.child("cards").child(uniqueIDString).observeSingleEvent(of: .value, with: { (snapshot) in
            var card = [String:[String]]()
            for childSnap in snapshot.children {
                let snap = childSnap as! DataSnapshot
                if card[snap.key] == nil {
                    card[snap.key] = [String]()
                }
                for more in snap.children {
                    let moreSnap = more as! DataSnapshot
                    card[snap.key]?.append(moreSnap.value as! String)
                    print(moreSnap.value as! String)
                }
            }
            completionHandler(card)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func logOutUser() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
    
    static func isUserLoggedIn() -> User? {
        return Auth.auth().currentUser
    }
    
    static func logInUser(with accessToken: String, completionHandler: @escaping (User?, Error?) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            completionHandler(user, error)
        }
    }
}
