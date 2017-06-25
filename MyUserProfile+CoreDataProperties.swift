//
//  MyUserProfile+CoreDataProperties.swift
//  familiarize
//
//  Created by Alex Oh on 6/24/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

extension MyUserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyUserProfile> {
        return NSFetchRequest<MyUserProfile>(entityName: "MyUserProfile")
    }

    @NSManaged public var bio: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var faceBookProfile: String?
    @NSManaged public var instagramProfile: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImage: NSData?
    @NSManaged public var snapChatProfile: String?

    
    static func getData() -> [MyUserProfile]{
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUserProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try(managedObjectContext.fetch(fetchRequest)) as! [MyUserProfile]
            
        } catch let err {
            print(err)
        }
        return []
    }
    
    static func saveData(_ qrJSON: JSON) -> MyUserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "MyUserProfile", into: managedObjectContext) as! MyUserProfile
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
    
    static func saveProfileImage(_ profileImage: Data, userObject newUser: MyUserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        newUser.profileImage = profileImage as NSData
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUserProfile")
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
