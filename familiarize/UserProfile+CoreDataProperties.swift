//
//  UserProfile+CoreDataProperties.swift
//  familiarize
//
//  Created by Alex Oh on 6/4/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var faceBookProfile: String?
    @NSManaged public var instagramProfile: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var snapChatProfile: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var profileImage: Data?
    @NSManaged public var bio: String?

    static func getData() -> [UserProfile]{
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try(managedObjectContext.fetch(fetchRequest)) as! [UserProfile]
            
        } catch let err {
            print(err)
        }
        return []
    }
    
    static func saveData(_ qrJSON: JSON) -> UserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
        newUser.name = qrJSON["name"].string
        newUser.faceBookProfile = qrJSON["fb"].string
        newUser.instagramProfile = qrJSON["ig"].string
        newUser.snapChatProfile = qrJSON["sc"].string
        newUser.phoneNumber = qrJSON["pn"].string
        newUser.bio = qrJSON["bio"].string
        
        newUser.date = NSDate()
        do {
            try(managedObjectContext.save())
            NotificationCenter.default.post(name: .reload, object: nil)
        } catch let err {
            print(err)
        }
        return newUser
    }
    
    static func saveProfileImage(_ profileImage: Data, userObject newUser: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        newUser.profileImage = profileImage as Data
        do {
            try(managedObjectContext.save())
            NotificationCenter.default.post(name: .reload, object: nil)
        } catch let err {
            print(err)
        }
    }
    
    // This is just a test run on how we can utilize clearData within the contactsVC
    static func clearData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let userProfiles = try(managedObjectContext.fetch(fetchRequest)) as? [UserProfile]
            for userProfile in userProfiles! {
                managedObjectContext.delete(userProfile)                
            }
        } catch let err {
            print(err)
        }
    }

}
