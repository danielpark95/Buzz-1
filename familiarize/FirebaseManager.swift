//
//  FirebaseManager.swift
//  familiarize
//
//  Created by Alex Oh on 7/28/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


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
    
    class fetchedCard {
        var card: [String: [String]]?
        var uniqueID: UInt64?
        
        init(card: [String: [String]], uniqueID: UInt64) {
            self.card = card
            self.uniqueID = uniqueID
        }
    }

    static func getCards(userProfileSelection: UserProfile.userProfileSelection, completionHandler: @escaping (([fetchedCard]?) -> Void)) {
        
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
        
        let asyncDispatchGroup = DispatchGroup()

        var cardsID: [UInt64] = []
        var cards: [fetchedCard] = []
        
        var cardType: String = ""
        if userProfileSelection == .myUser {
            cardType = "cards"
        } else {
            cardType = "otherCards"
        }
        
        asyncDispatchGroup.enter()
        databaseRef.child("users").child(userID).child(cardType).observeSingleEvent(of: .value, with: { (snapshot) in
            for childSnap in snapshot.children {
                let snap = childSnap as! DataSnapshot
                let uniqueIDString = snap.value as! String
                let uniqueID = UInt64(uniqueIDString) ?? 0
                cardsID.append(uniqueID)
            }
            for uniqueID in cardsID {
                asyncDispatchGroup.enter()
                getCard(withUniqueID: uniqueID, isARefetch: true, completionHandler: { (card, error) in
                    guard let card = card else { return }
                    cards.append(fetchedCard(card: card, uniqueID: uniqueID))
                    asyncDispatchGroup.leave()
                })
            }
            asyncDispatchGroup.leave()
        })
        
        asyncDispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(cards)
        })
    }
    
    static func sendCard(receiverUID: String, cardUID: UInt64) {
        let uniqueIDString = String(cardUID)
        // Just pass up a true value to these certain paths and then a notification will be sent to that corresponding user!
        databaseRef.child("notificationQueue").child(receiverUID).child(uniqueIDString).child("Alex Oh").setValue("true")
    }
    
    static func updateFCMToken() {
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        databaseRef.child("users").child(userID).updateChildValues(["fcmToken": fcmToken])
    }
    
    static func deleteCard(uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
        
        databaseRef.child("cards").child(uniqueIDString).removeValue()
        databaseRef.child("users").child(userID).child("cards").observeSingleEvent(of: .value, with: { (snapshot) in
            var childByAutoIDKey: String?
            for childSnap in snapshot.children {
                let snap = childSnap as! DataSnapshot
                if snap.value as! String == uniqueIDString {
                    childByAutoIDKey = snap.key
                    break
                }
            }
            guard let key = childByAutoIDKey else { return }
            databaseRef.child("users").child(userID).child("cards").child(key).removeValue()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func generateUniqueID() -> UInt64 {
        return UInt64(arc4random()) + (UInt64(arc4random()) << 32)
    }
    
    static func uploadCard(_ userCard: [String:[String]], withUniqueID uniqueID: UInt64) {
        let uniqueIDString = String(uniqueID)
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
        databaseRef.child("users").child(userID).child("cards").childByAutoId().setValue(uniqueIDString)
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
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
        
        // Create a reference to the file you want to upload
        let profileImageRef = storageRef.child("\(userID)/\(UUID().uuidString)")

        _ = profileImageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else { return }
            completionHandler((metadata.downloadURL()?.absoluteString)!)
        }
    }
    
    static func getCard(withUniqueID uniqueID: UInt64, isARefetch: Bool = false, completionHandler: @escaping ([String:[String]]?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { return }
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
                    
                    print("This is value: ", moreSnap.value as! String)
                }
            }
            completionHandler(card, nil)
        }) { (error) in
            completionHandler(nil, error)
            print(error.localizedDescription)
        }
        
        if isARefetch == false {
            databaseRef.child("users").child(userID).child("otherCards").childByAutoId().setValue(uniqueIDString)
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
    
    static func facebookLogIn(controller: LoginController, loginCompleted: @escaping () -> Void) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: controller) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            // Perform login by calling Firebase APIs
            FirebaseManager.logInUser(with: accessToken.tokenString, completionHandler: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    return
                }
                loginCompleted()
            })
        }
    }
    
    static func signUp(email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completionHandler(user, error)
        }
    }
    
    static func signIn(email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completionHandler(user, error)
        }
    }
    
    static func resetPassword(email: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completionHandler(error)
        }
    }
}

/*
Attempt at trying to find unique id.
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







