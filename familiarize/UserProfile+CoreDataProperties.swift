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
    
    @NSManaged public var venmoProfile: [String]?
    @NSManaged public var slackProfile: [String]?
    @NSManaged public var gitHubProfile: [String]?
    @NSManaged public var spotifyProfile: [String]?
    @NSManaged public var kakaoTalkProfile: [String]?
    @NSManaged public var whatsAppProfile: [String]?
    
    
    @NSManaged public var profileImageApp: String?
    @NSManaged public var profileImageURL: String?
    @NSManaged public var uniqueID: NSNumber?
    @NSManaged var userProfileSelection: userProfileSelection
    
    static let singleInputUserData: Set<String> = ["name", "bio", "profileImageApp", "profileImageURL"]
    static let multipleInputUserData: Set<String> = ["email", "phoneNumber", "faceBookProfile", "instagramProfile", "snapChatProfile", "linkedInProfile", "soundCloudProfile", "twitterProfile", "venmoProfile", "slackProfile", "gitHubProfile", "spotifyProfile", "kakaoTalkProfile", "whatsAppProfile"]
    
    static let editableSingleInputUserData: Set<String> = ["name", "bio"]
    static let editableMultipleInputUserData: Set<String> = UserProfile.multipleInputUserData
    
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    static let managedObjectContext = delegate.persistentContainer.viewContext
    
    static func updateSocialMediaProfileImage(_ socialMediaProfileURL: String, withUserProfile userProfile: UserProfile) {
        userProfile.profileImageApp = "default"
        userProfile.profileImageURL = socialMediaProfileURL
        do {
            try(managedObjectContext.save())
            let profileImageInfo: [String:String] = ["profileImageApp": userProfile.profileImageApp!, "profileImageURL": userProfile.profileImageURL!]
            FirebaseManager.updateCard(profileImageInfo, withUniqueID: userProfile.uniqueID as! UInt64)
        } catch let err {
            print(err)
        }
    }
    
    static func updateProfile(_ socialMediaInputs: [SocialMedia], userProfile: UserProfile) -> UserProfile {
        DiskManager.deleteImageFromLocal(withUniqueID: userProfile.uniqueID as! UInt64)
        var userCard = [String:[String]]()
        for eachSocialMediaInput in socialMediaInputs {
            if userCard[eachSocialMediaInput.appName!] == nil {
                userCard[eachSocialMediaInput.appName!] = [String]()
            }
            userCard[eachSocialMediaInput.appName!]?.append(eachSocialMediaInput.inputName!)
        }
        
        // Zero out all the data.
        for key in userProfile.entity.propertiesByName.keys {
            if multipleInputUserData.contains(key) {
                userProfile.setValue(nil, forKeyPath: key)
            }
        }
        
        // Put in new data.
        for key in userProfile.entity.propertiesByName.keys {
            if userCard[key] != nil && multipleInputUserData.contains(key) {
                var input = [String]()
                for eachInput in userCard[key]! {
                    input.append(eachInput)
                }
                userProfile.setValue(input, forKeyPath: key)
            } else if userCard[key] != nil && singleInputUserData.contains(key) {
                userProfile.setValue(userCard[key]?.first, forKeyPath: key)
            }
        }
        
        userProfile.date = NSDate()
        
        FirebaseManager.updateCard(userCard, withUniqueID: userProfile.uniqueID!.uint64Value)
        
        do {
            try(managedObjectContext.save())
        } catch let err {
            print(err)
        }
        return userProfile
    }
    
    static func saveProfileWrapper(_ socialMediaInputs: [SocialMedia], withUniqueID uniqueID: UInt64) -> UserProfile {
        var userCard = [String:[String]]()
        for eachSocialMediaInput in socialMediaInputs {
            if userCard[eachSocialMediaInput.appName!] == nil {
                userCard[eachSocialMediaInput.appName!] = [String]()
            }
            userCard[eachSocialMediaInput.appName!]?.append(eachSocialMediaInput.inputName!)
        }
        
        let userProfile = UserProfile.saveProfile(userCard, forProfile: .myUser, withUniqueID: uniqueID)
        return userProfile
    }
    
    static func saveProfile(_ userCard: [String:[String]], forProfile userProfile: userProfileSelection, withUniqueID uniqueID: UInt64) -> UserProfile {
        // NSCore data functionalities. -- Persist the data when user scans!
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
        
        for key in newUser.entity.propertiesByName.keys {
            if userCard[key] != nil && multipleInputUserData.contains(key) {
                var input = [String]()
                for eachInput in userCard[key]! {
                    input.append(eachInput)
                }
                newUser.setValue(input, forKeyPath: key)
            } else if userCard[key] != nil && singleInputUserData.contains(key) {
                newUser.setValue(userCard[key]?.first, forKeyPath: key)
            }
        }

        // Create a global unique ID. And after that, push this new card into Firebase so that anyone can access it one day.
        newUser.uniqueID = NSNumber(value: uniqueID)
        
        // If this is my user that I am saving, then push it to the cloud.
        if userProfile == .myUser {
            FirebaseManager.uploadCard(userCard, withUniqueID: newUser.uniqueID!.uint64Value)
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
        managedObjectContext.delete(user)
        do {
            try managedObjectContext.save()
        } catch let err {
            print("Deleting didn't go so well.")
            print(err)
        }
    }
    
    // This is just a test run on how we can utilize clearData within the contactsVC
    static func clearData(forProfile userProfile: userProfileSelection) {
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
