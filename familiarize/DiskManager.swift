//
//  DiskController.swift
//  familiarize
//
//  Created by Alex Oh on 8/14/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

enum ImageDataType {
    case profileImage
    case qrCodeImage
}

class DiskManager {
    
    static let documentsURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    static let fileManager: FileManager = {
        return FileManager.default
    }()
    
    static func writeImageDataToLocal(withData profileImageData:Data, withUniqueID uniqueID: UInt64, withUserProfileSelection userProfileSelection: UserProfile.userProfileSelection, imageDataType: ImageDataType) {
        do {
            var fileURL: URL?
            switch imageDataType {
            case .profileImage:
                fileURL = documentsURL.appendingPathComponent("profileImage/\(uniqueID).jpg")
            case .qrCodeImage:
                fileURL = documentsURL.appendingPathComponent("qrCodeImage/\(uniqueID).jpg")
            }
            
            try profileImageData.write(to: fileURL!, options: .atomic)
            DispatchQueue.main.async {
                if userProfileSelection == .myUser {
                    NotificationCenter.default.post(name: .reloadMeCards, object: nil)
                } else if userProfileSelection == .otherUser {
                    NotificationCenter.default.post(name: .reloadFriendCards, object: nil)
                }
            }
        } catch let err {
            print(err)
        }
    }
    
    static func readImageFromLocal(withUniqueID uniqueID: UInt64, imageDataType: ImageDataType) -> UIImage? {
        
        var filePath: String?
        switch imageDataType {
        case .profileImage:
            filePath = documentsURL.appendingPathComponent("profileImage/\(uniqueID).jpg").path
        case .qrCodeImage:
            filePath = documentsURL.appendingPathComponent("qrCodeImage/\(uniqueID).jpg").path
        }
        
        if fileManager.fileExists(atPath: filePath!) {
            return UIImage(contentsOfFile: filePath!)
        } else {
            print("There are no images here")
        }
        return nil
    }
    
    static func deleteImageFromLocal(withUniqueID uniqueID: UInt64, imageDataType: ImageDataType) {
        
        var fileURL: URL?
        switch imageDataType {
        case .profileImage:
            fileURL = documentsURL.appendingPathComponent("profileImage/\(uniqueID).jpg")
        case .qrCodeImage:
            fileURL = documentsURL.appendingPathComponent("qrCodeImage/\(uniqueID).jpg")
        }
        
        do {
            try fileManager.removeItem(at: fileURL!)
        } catch let err {
            print(err)
        }
    }
}
