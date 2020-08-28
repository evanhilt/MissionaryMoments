//
//  EventTypes.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation
import SwiftUI

enum EventEnum: Int, CaseIterable {
    case casual = 0
    case doctrine = 1
    case missionaries = 2
    case church = 3
    case service = 4

    public func eventString() -> String {
        switch self {
            case .casual:
                return "Casual"
            case .doctrine:
                return "Doctrine"
            case .missionaries:
                return "Missionaries"
            case .church:
                return "Church"
            case .service:
                return "Service"
        }
    }
    
    public func getImage() -> Image {
        switch self {
            case .casual:
                return Image(uiImage: UIImage(named: "Casual")!)
            case .doctrine:
                return Image(uiImage: UIImage(named: "Doctrine")!)
            case .missionaries:
                return Image(uiImage: UIImage(named: "Missionaries")!)
            case .church:
                return Image(uiImage: UIImage(named: "Church")!)
            case .service:
                return Image(uiImage: UIImage(named: "Service")!)
        }
    }
}
