//
//  TimeStrings.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation

public func timeString(time: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy hh:mm a"
    return formatter.string(from: time)
}

public func nameString(_ id: Int) -> String {
    let dataExchanger = DataExchanger()
    let friend = dataExchanger.getFriend(id: id)
    return "\(friend!.firstName) \(friend!.lastName)"
}

public func memberString(_ member: Bool) -> String {
    if(member == true) {
        return "Member"
    } else {
        return "Non-Member"
    }
}

public func formatPhoneNumber(_ number: String) -> String {
    let phoneInt = Int(number.filter("0123456789".contains)) ?? 0
    if phoneInt == 0 {
        return ""
    }
    var offset = 0
    var num = String(phoneInt)
    let numCount = num.count
    if num.first == "0" {
        return num
    } else if num.first == "1" {
        if numCount > 1 {
            print("second char: \(num[1])")
            if num[1] == "0" {
                return num
            } else {
                num.insert(" ", at: num.index(num.startIndex, offsetBy: 1))
                offset = 2
            }
        }
        if numCount == 4 {
            return num
        }
    }
    if numCount < 11 && num.first != "1" || numCount < 12 && num.first == "1" {
        if numCount > 3 {
            if numCount < 8  {
                num.insert("-", at: num.index(num.startIndex, offsetBy: 3 + offset))
            } else {
                num.insert("(", at: num.index(num.startIndex, offsetBy: 0 + offset))
                num.insert(")", at: num.index(num.startIndex, offsetBy: 4 + offset))
                num.insert(" ", at: num.index(num.startIndex, offsetBy: 5 + offset))
                num.insert("-", at: num.index(num.startIndex, offsetBy: 9 + offset))
            }
        } else if numCount == 3 {
            return num
        }
    }
    return num
}
