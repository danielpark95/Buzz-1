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
    
    static func writeImageDataToLocal(withData data:Data, withUniqueID uniqueID: UInt64) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(uniqueID).png")
            let profileImage = UIImage(data: data)
            if let pngImageData = UIImageJPEGRepresentation(profileImage!, 1.0){
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("Data was not able to be stored in disk successfully.")
        }
    }
    
    static func readImageFromLocal(withUniqueID uniqueID: UInt64) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(uniqueID).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
}
