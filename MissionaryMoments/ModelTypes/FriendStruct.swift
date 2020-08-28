//
//  FriendStruct.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/20/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation
import SwiftUI

struct FriendStruct: Identifiable, Hashable {
    let id: Int
    let contactsId: Int?
    let firstName: String
    let lastName: String
    let gender: GenderEnum
    let phoneNumber: Int
    let photo: Data?
    let age: Int?
    let member: Bool
}
