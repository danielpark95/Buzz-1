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
    
    static let editableUserData: Set<String> = ["phoneNumber", "faceBookProfile", "instagramProfile", "snapChatProfile", "linkedInProfile", "email", "twitterProfile", "soundCloudProfile", "name", "bio"]
    static let singleInputUserData: Set<String> = ["name", "bio", "profileImageApp", "profileImageURL"]
 
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
        
        for key in newUser.entity.propertiesByName.keys {
            if cardJSON[key] != nil && singleInputUserData.contains(key) == false {
                var input = [String]()
                for eachInput in cardJSON[key]! {
                    input.append(eachInput)
                }
                newUser.setValue(input, forKeyPath: key)
            } else if cardJSON[key] != nil && singleInputUserData.contains(key) == true {
                newUser.setValue(cardJSON[key]?[0], forKeyPath: key)
            }
        }

        // Create a global unique ID. And after that, push this new card into Firebase so that anyone can access it one day.
        newUser.uniqueID = NSNumber(value: UInt64(FirebaseManager.generateUniqueID()))
        newUser.uniqueID = 69
        print("This is the unique ID: \(newUser.uniqueID)")
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
