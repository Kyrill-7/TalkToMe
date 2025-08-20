//
//  Item.swift
//  TalkToMe
//
//  Created by Dhruv Chaudhari on 12/08/25.
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
