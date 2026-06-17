//
//  MIDIButton.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//

import SwiftData
import Foundation

@Model
final class Pad {
    var id: UUID
    var name: String
    var ccNumber: Int
    var value: Int
    var createdAt: Date
    
    init(id: UUID, name: String, ccNumber: Int, value: Int, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.ccNumber = ccNumber
        self.value = value
        self.createdAt = createdAt
    }
}
