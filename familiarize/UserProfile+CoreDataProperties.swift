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
    
    @NSManaged public var name: String?
    @NSManaged public var bio: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var faceBookProfile: String?
    @NSManaged public var instagramProfile: String?
    @NSManaged public var snapChatProfile: String?
    @NSManaged public var profileImage: Data?
    @NSManaged public var linkedInProfile: String?
    @NSManaged public var soundCloudProfile: String?
    @NSManaged public var twitterProfile: String?
    @NSManaged public var profileImageApp: String?
    @NSManaged public var profileImageURL: String?
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
    
    static func updateSocialMediaProfileImage(_ socialMediaProfileURL: String, withSocialMediaProfileApp socialMediaProfileApp: String, withUserProfile userProfile: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        userProfile.profileImageApp = socialMediaProfileApp
        userProfile.profileImageURL = socialMediaProfileURL
        do {
            try(managedObjectContext.save())
            NotificationCenter.default.post(name: .reload, object: nil)
        } catch let err {
            print(err)
        }
    }
    
    static func saveProfileWrapper(_ socialMediaInputs: [SocialMedia], withSocialMediaProfileImage socialMediaProfileImage: SocialMediaProfileImage) -> UserProfile {
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
        // Previous errors with this => must be initialized with:
        // [:] to create an empty dictionary. [] creates an empty array and is wrong.
        var toSaveCard: JSON = [:]
        for eachConcantenatedSocialMediaInput in concantenatedSocialMediaInputs {
            let currentSocialMediaName = eachConcantenatedSocialMediaInput.socialMediaName
            toSaveCard[currentSocialMediaName].string = eachConcantenatedSocialMediaInput.inputName
        }
        
        
        // profileImageApp
        // When default profile image is chosen, then the appName is: default
        // profileImageURL
        // When default profile image is chosen, then the inputName is the url link to the image
        toSaveCard["profileImageApp"].string = socialMediaProfileImage.appName
        toSaveCard["profileImageURL"].string = socialMediaProfileImage.inputName
        
        let userProfile = UserProfile.saveProfile(toSaveCard, forProfile: .myUser)
        let profileImageData = UIManager.makeCardProfileImageData(UIImagePNGRepresentation(socialMediaProfileImage.profileImage!)! , withImageXCoordPadding: -230)
        UserProfile.saveProfileImage(profileImageData, withUserProfile: userProfile)
        return userProfile
    }
    
    static func saveProfile(_ qrJSON: JSON, forProfile userProfile: userProfileSelection) -> UserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile

        if (qrJSON["name"].exists()) {
            newUser.name = qrJSON["name"].string
        }
        if (qrJSON["bio"].exists()) {
            newUser.bio = qrJSON["bio"].string
        }
        if (qrJSON["faceBookProfile"].exists()) {
            newUser.faceBookProfile = qrJSON["faceBookProfile"].string
        }
        if (qrJSON["snapChatProfile"].exists()) {
            newUser.snapChatProfile = qrJSON["snapChatProfile"].string
        }
        if (qrJSON["instagramProfile"].exists()) {
            newUser.instagramProfile = qrJSON["instagramProfile"].string
        }
        if (qrJSON["email"].exists()) {
            newUser.email = qrJSON["email"].string
        }
        if (qrJSON["phoneNumber"].exists()) {
            newUser.phoneNumber = qrJSON["phoneNumber"].string
        }
        if (qrJSON["linkedInProfile"].exists()) {
            newUser.linkedInProfile = qrJSON["linkedInProfile"].string
        }
        if (qrJSON["twitterProfile"].exists()) {
            newUser.twitterProfile = qrJSON["twitterProfile"].string
        }
        if (qrJSON["soundCloudProfile"].exists()) {
            newUser.soundCloudProfile = qrJSON["soundCloudProfile"].string
        }
        if (qrJSON["profileImageApp"].exists()) {
            newUser.profileImageApp = qrJSON["profileImageApp"].string
        }
        if (qrJSON["profileImageURL"].exists()) {
            newUser.profileImageURL = qrJSON["profileImageURL"].string
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
    
    static func saveProfileImage(_ profileImage: Data, withUserProfile userProfile: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        userProfile.profileImage = profileImage as Data
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
