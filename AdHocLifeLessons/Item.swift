//
//  Item.swift
//  AdHocLifeLessons
//
//  Created by Rohan Deshpande on 7/31/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
