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

    @objc enum userProfileSelection: Int16 {
        case myUser
        case otherUser
    }
    
    
    /*
 
 
 //        if (cardJSON["snapChatProfile"] != nil) {
 //            newUser.snapChatProfile = cardJSON["snapChatProfile"].string
 //        }
 //        if (cardJSON["instagramProfile"] != nil) {
 //            newUser.instagramProfile = cardJSON["instagramProfile"].string
 //        }
 //        if (cardJSON["email"] != nil) {
 //            newUser.email = cardJSON["email"].string
 //        }
 //        if (cardJSON["phoneNumber"] != nil) {
 //            newUser.phoneNumber = cardJSON["phoneNumber"].string
 //        }
 //        if (cardJSON["linkedInProfile"] != nil) {
 //            newUser.linkedInProfile = cardJSON["linkedInProfile"].string
 //        }
 //        if (cardJSON["twitterProfile"] != nil) {
 //            newUser.twitterProfile = cardJSON["twitterProfile"].string
 //        }
 //        if (cardJSON["soundCloudProfile"] != nil) {
 //            newUser.soundCloudProfile = cardJSON["soundCloudProfile"].string
 
 */
    @NSManaged public var name: String?
    @NSManaged public var bio: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var email: [String]?
    @NSManaged public var phoneNumber: [String]?
    @NSManaged public var faceBookProfile: [String]?
    @NSManaged public var instagramProfile: [String]?
    @NSManaged public var snapChatProfile: [String]?
    @NSManaged public var linkedInProfile: [String]?
    @NSManaged public var soundCloudProfile: [String]?
    @NSManaged public var twitterProfile: [String]?
    @NSManaged public var profileImageApp: String?
    @NSManaged public var profileImageURL: String?
    @NSManaged public var uniqueID: NSNumber?
    @NSManaged var userProfileSelection: userProfileSelection
    
    static func updateSocialMediaProfileImage(_ socialMediaProfileURL: String, withSocialMediaProfileApp socialMediaProfileApp: String, withUserProfile userProfile: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        userProfile.profileImageApp = socialMediaProfileApp
        userProfile.profileImageURL = socialMediaProfileURL
        do {
            try(managedObjectContext.save())
            let newCardJSON: JSON = JSON(["profileImageApp":socialMediaProfileApp, "profileImageURL": socialMediaProfileURL])
            FirebaseManager.updateCard(newCardJSON, withUniqueID: userProfile.uniqueID as! UInt64)
        } catch let err {
            print(err)
        }
    }
    
    static func saveProfileWrapper(_ socialMediaInputs: [SocialMedia], withSocialMediaProfileImage socialMediaProfileImage: SocialMediaProfileImage) -> UserProfile {
        
        // There's always going to be a profile image. Either default or not.
        // Previous errors with this => must be initialized with:
        // [:] to create an empty dictionary. [] creates an empty array and is wrong.
        var userCard = [String:[String]]()
        for eachSocialMediaInput in socialMediaInputs {
            if userCard[eachSocialMediaInput.appName!] == nil {
                userCard[eachSocialMediaInput.appName!] = [String]()
            }
            userCard[eachSocialMediaInput.appName!]?.append(eachSocialMediaInput.inputName!)
        }
    
        // profileImageApp
        // When default profile image is chosen, then the appName is: default
        // profileImageURL
        // When default profile image is chosen, then the inputName is the url link to the image
        
        userCard["profileImageApp"] = [String]()
        userCard["profileImageApp"]?.append(socialMediaProfileImage.appName!)
        userCard["profileImageURL"] = [String]()
        userCard["profileImageURL"]?.append(socialMediaProfileImage.inputName!)
        
        let userProfile = UserProfile.saveProfile(userCard, forProfile: .myUser)
        return userProfile
    }
    
    static func saveProfile(_ cardJSON: [String:[String]], forProfile userProfile: userProfileSelection) -> UserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
        
        if (cardJSON["name"] != nil) {
            for eachInput in cardJSON["name"]! {
                newUser.name = eachInput
            }
        }
        if (cardJSON["bio"] != nil) {
            for eachInput in cardJSON["bio"]! {
                newUser.bio = eachInput
            }
        }
        if (cardJSON["faceBookProfile"] != nil) {
            newUser.faceBookProfile = [String]()
            for eachInput in cardJSON["faceBookProfile"]! {
                newUser.faceBookProfile?.append(eachInput)
            }
        }
        if (cardJSON["snapChatProfile"] != nil) {
            newUser.snapChatProfile = [String]()
            for eachInput in cardJSON["snapChatProfile"]! {
                newUser.snapChatProfile?.append(eachInput)
            }
        }
        if (cardJSON["instagramProfile"] != nil) {
            newUser.instagramProfile = [String]()
            for eachInput in cardJSON["instagramProfile"]! {
                newUser.instagramProfile?.append(eachInput)
            }
        }
        if (cardJSON["email"] != nil) {
            newUser.email = [String]()
            for eachInput in cardJSON["email"]! {
                newUser.email?.append(eachInput)
            }
        }
        if (cardJSON["phoneNumber"] != nil) {
            newUser.phoneNumber = [String]()
            for eachInput in cardJSON["phoneNumber"]! {
                newUser.phoneNumber?.append(eachInput)
            }
        }
        if (cardJSON["linkedInProfile"] != nil) {
            newUser.linkedInProfile = [String]()
            for eachInput in cardJSON["linkedInProfile"]! {
                newUser.linkedInProfile?.append(eachInput)
            }
        }
        if (cardJSON["twitterProfile"] != nil) {
            newUser.twitterProfile = [String]()
            for eachInput in cardJSON["twitterProfile"]! {
                newUser.twitterProfile?.append(eachInput)
            }
        }
        if (cardJSON["soundCloudProfile"] != nil) {
            newUser.soundCloudProfile = [String]()
            for eachInput in cardJSON["soundCloudProfile"]! {
                newUser.soundCloudProfile?.append(eachInput)
            }
        }
        if (cardJSON["profileImageApp"] != nil) {
            for eachInput in cardJSON["profileImageApp"]! {
                newUser.profileImageApp = eachInput
            }
        }
        if (cardJSON["profileImageURL"] != nil) {
            for eachInput in cardJSON["profileImageURL"]! {
                newUser.profileImageURL = eachInput
            }
        }

        // Create a global unique ID. And after that, push this new card into Firebase so that anyone can access it one day.
        newUser.uniqueID = NSNumber(value: UInt64(FirebaseManager.generateUniqueID()))
        // If this is my user that I am saving, then push it to the cloud.
        if userProfile == .myUser {
            FirebaseManager.uploadCard(cardJSON, withUniqueID: newUser.uniqueID!.uint64Value)
        }
        newUser.userProfileSelection = userProfile
        newUser.date = NSDate()
        do {
            try(managedObjectContext.save())
        } catch let err {
            print(err)
        }
        return newUser
    }
    
    static func deleteProfile(user: UserProfile) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        managedObjectContext.delete(user)
        do {
            try managedObjectContext.save()
        } catch let err {
            print(err)
        }
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
