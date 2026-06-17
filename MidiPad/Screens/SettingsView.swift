//
//  SettingsScreen.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//

import SwiftUI

struct SettingsView : View {
    @EnvironmentObject var midi: MIDIManager
    @State private var isShowingMIDIModal = false

    var body: some View {
        Form {
            Section("Bluetooth MIDI") {
                Button(action: {
                    isShowingMIDIModal = true
                }) {
                    Text("Show Bluetooth MIDI devices")
                }
            }
            Section("MIDI Device") {
                Picker("Selected device", selection: $midi.selectedDestination) {
                    ForEach(midi.destinations) { dest in
                        Text(dest.name).tag(dest.id)
                    }
                }
                .pickerStyle(.menu)
            }

        }
        .onAppear {
            midi.setupIfNeeded()
        }
        .sheet(isPresented: $isShowingMIDIModal) {
            BluetoothMIDIView()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(MIDIManager())
}
