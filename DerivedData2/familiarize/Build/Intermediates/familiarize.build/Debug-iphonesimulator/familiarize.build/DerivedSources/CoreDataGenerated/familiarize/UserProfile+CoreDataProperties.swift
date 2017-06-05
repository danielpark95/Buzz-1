//
//  UserProfile+CoreDataProperties.swift
//  
//
//  Created by Alex Oh on 6/4/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var faceBookProfile: String?
    @NSManaged public var instagramProfile: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var snapChatProfile: String?

}
