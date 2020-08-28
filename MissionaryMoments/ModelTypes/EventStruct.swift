//
//  EventType.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/14/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation

struct EventStruct: Identifiable, Hashable {
    let id: Int
    let friendId: Int
    let time: Foundation.Date
    let title: String
    let notes: String
    let eventType: EventEnum
}
