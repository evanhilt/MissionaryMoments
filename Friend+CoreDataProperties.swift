//
//  Friend+CoreDataProperties.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/17/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var age: Int32
    @NSManaged public var contactsId: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var gender: Int32
    @NSManaged public var id: Int32
    @NSManaged public var lastName: String?
    @NSManaged public var member: Bool
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var photo: Data?

}
