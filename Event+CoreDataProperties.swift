//
//  Event+CoreDataProperties.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/17/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventType: Int32
    @NSManaged public var friendId: Int32
    @NSManaged public var id: Int32
    @NSManaged public var notes: String?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?

}
