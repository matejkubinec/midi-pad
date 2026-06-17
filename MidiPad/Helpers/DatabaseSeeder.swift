//
//  DatabaseSeeder.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//

import SwiftData
import Foundation

struct DatabaseSeeder {

    @MainActor
    static func seed(
        context: ModelContext
    ) throws {

        let count = try context.fetchCount(
            FetchDescriptor<Pad>()
        )

        guard count == 0 else {
            return
        }
        
        for pad in 49..<59 {
            let pad = Pad(id: UUID(), name: "FS \(pad - 48)", ccNumber: pad, value: 127)
            context.insert(pad)
        }

        try context.save()
    }
}
