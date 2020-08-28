//
//  StringExtensions.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/25/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
