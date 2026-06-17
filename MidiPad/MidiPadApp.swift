//
//  MidiPadApp.swift
//  MidiPad
//
//  Created by Matej Kubinec on 17/06/2026.
//

import SwiftUI
import SwiftData

@main
struct MidiPadApp: App {
    @StateObject private var midiManager = MIDIManager()
    
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Pad.self
            )

            try DatabaseSeeder.seed(
                context: container.mainContext
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Pad.self
        ])
        .environmentObject(midiManager)
    }
}
