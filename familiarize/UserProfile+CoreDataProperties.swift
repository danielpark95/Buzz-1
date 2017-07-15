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

    @objc enum userProfileSelection: Int32 {
        case myUser
        case otherUser
    }
    
    @NSManaged public var faceBookProfile: String?
    @NSManaged public var instagramProfile: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var snapChatProfile: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var profileImage: Data?
    @NSManaged public var bio: String?
    @NSManaged public var linkedInProfile: String?
    @NSManaged public var email: String?
    @NSManaged var userProfileSelection: userProfileSelection

    static func getData(forUserProfile userProfile: userProfileSelection) -> [UserProfile]{
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.predicate = NSPredicate(format: "userProfileSelection == %@", argumentArray: [userProfile.rawValue])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try(managedObjectContext.fetch(fetchRequest)) as! [UserProfile]
        } catch let err {
            print(err)
        }
        return []
    }
    
    static func saveProfileWrapper(_ socialMediaInputs: [SocialMedia], withSocialMediaProfileImage socialMediaProfileImage: SocialMediaProfileImage) {
        var concantenatedSocialMediaInputs: [(socialMediaName: String, inputName: String)] = []
        
        var currentSocialMediaName: String = ""
        for eachSocialInput in socialMediaInputs {
            if eachSocialInput.appName == currentSocialMediaName {
                concantenatedSocialMediaInputs[(concantenatedSocialMediaInputs.count)-1].inputName = concantenatedSocialMediaInputs[(concantenatedSocialMediaInputs.count)-1].inputName + ",\(eachSocialInput.inputName!)"
            } else {
                currentSocialMediaName = eachSocialInput.appName!
                concantenatedSocialMediaInputs.append((eachSocialInput.appName!, eachSocialInput.inputName!))
                print(concantenatedSocialMediaInputs.count)
            }
        }
        
        // There's always going to be a profile image. Either default or not.
        var toSaveCard: JSON = ["pi": ["an":"", "in":""]]
        for eachConcantenatedSocialMediaInput in concantenatedSocialMediaInputs {
            let currentSocialMediaName = UIManager.makeShortHandForQR(eachConcantenatedSocialMediaInput.socialMediaName)
            toSaveCard[currentSocialMediaName!].string = eachConcantenatedSocialMediaInput.inputName
        }
        
        toSaveCard["pi"]["an"].string = UIManager.makeShortHandForQR(socialMediaProfileImage.appName!)
        toSaveCard["pi"]["in"].string = socialMediaProfileImage.inputName

        print(toSaveCard)
        
        let userProfile = UserProfile.saveProfile(toSaveCard, forProfile: .myUser)
        UserProfile.saveProfileImage(UIImagePNGRepresentation(socialMediaProfileImage.profileImage!)!, userObject: userProfile)
    }
    
    static func saveProfile(_ qrJSON: JSON, forProfile userProfile: userProfileSelection) -> UserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
        
        if (qrJSON["name"].exists()) {
            newUser.name = qrJSON["name"].string
        }
        if (qrJSON["fb"].exists()) {
            newUser.faceBookProfile = qrJSON["fb"].string
        }
        if (qrJSON["ig"].exists()) {
            newUser.instagramProfile = qrJSON["ig"].string
        }
        if (qrJSON["sc"].exists()) {
            newUser.snapChatProfile = qrJSON["sc"].string
        }
        if (qrJSON["pn"].exists()) {
            newUser.phoneNumber = qrJSON["pn"].string
        }
        if (qrJSON["bio"].exists()) {
            newUser.bio = qrJSON["bio"].string
        }
        if (qrJSON["in"].exists()) {
            newUser.linkedInProfile = qrJSON["in"].string
        }
        if (qrJSON["em"].exists()) {
            newUser.email = qrJSON["em"].string
        }

        newUser.userProfileSelection = userProfile
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
    
    static func deleteProfile(user: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        managedObjectContext.delete(user)
    }
    
    // This is just a test run on how we can utilize clearData within the contactsVC
    static func clearData(forProfile userProfile: userProfileSelection) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.predicate = NSPredicate(format: "userProfileSelection == %@", argumentArray: [userProfile.rawValue])
        
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
