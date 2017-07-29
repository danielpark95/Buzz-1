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
    
    static func uploadImageToFirebase(_ imageData: Data) {
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {

                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(downloadURL)
        }
    }
    
}
