//
//  LifeLesson.swift
//  AdHocLifeLessons
//
//  Created by Rohan Deshpande on 7/31/25.
//

import Foundation
import SwiftData

@Model
final class LifeLesson {
    var timestamp: String
    var version: Int
    var lesson: String
    var lastUpdated: Date
    
    init(timestamp: String, version: Int, lesson: String, lastUpdated: Date = Date()) {
        self.timestamp = timestamp
        self.version = version
        self.lesson = lesson
        self.lastUpdated = lastUpdated
    }
}
