//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Alex Oh on 6/4/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var attribute: NSObject?

}
