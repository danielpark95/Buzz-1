//
//  DiskController.swift
//  familiarize
//
//  Created by Alex Oh on 8/14/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

class DiskManager {
    
    static let documentsURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    static func writeImageDataToLocal(withData data:Data, withUniqueID uniqueID: UInt64, withUserProfileSelection userProfileSelection: UserProfile.userProfileSelection) {
        do {
            let fileURL = documentsURL.appendingPathComponent("\(uniqueID).png")
            let profileImage = UIImage(data: data)
            if let pngImageData = UIImageJPEGRepresentation(profileImage!, 1.0){
                try pngImageData.write(to: fileURL, options: .atomic)
                DispatchQueue.main.async {
                    if userProfileSelection == .myUser {
                        NotificationCenter.default.post(name: .reloadMeCards, object: nil)
                    } else if userProfileSelection == .otherUser {
                        NotificationCenter.default.post(name: .reloadFriendCards, object: nil)
                    }
                }
            }
        } catch let err {
            print(err)
        }
    }
    
    static func readImageFromLocal(withUniqueID uniqueID: UInt64) -> UIImage? {
        let filePath = documentsURL.appendingPathComponent("\(uniqueID).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        } else {
            print("There are no images here")
        }
        return nil
    }
    
    static func deleteImageFromLocal(withUniqueID uniqueID: UInt64) {
        let filePath = documentsURL.appendingPathComponent("\(uniqueID).png")
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: filePath)
        } catch let err {
            print(err)
        }
    }
}
