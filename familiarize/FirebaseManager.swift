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
    
    static func uploadImageToFirebase(_ socialMediaProfileImage: SocialMediaProfileImage, completionHandler: @escaping (String) -> Void) {
        let profileImage = UIImagePNGRepresentation(socialMediaProfileImage.profileImage!)
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("\(UIDevice.current.identifierForVendor!.uuidString)/\(UUID().uuidString)")
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            completionHandler((metadata.downloadURL()?.absoluteString)!)
        }
    }
    
}
