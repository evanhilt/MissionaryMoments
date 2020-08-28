//
//  GenderEnum.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/5/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation

enum GenderEnum: Int, CaseIterable {
    case female = 0
    case male = 1
    
    public func toString() -> String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        }
    }
}
