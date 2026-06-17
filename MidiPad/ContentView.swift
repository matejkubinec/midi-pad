//
//  ContentView.swift
//  MidiPad
//
//  Created by Matej Kubinec on 17/06/2026.
//

import SwiftUI
import Combine
import SwiftData
import CoreMIDI


struct ContentView: View {
    @State private var isShowingMIDIModal = false
    @StateObject private var midi = MIDIManager()
    @StateObject private var router = AppRouter()

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    private func checkSources() {
        midi.setupIfNeeded()
        midi.refreshDestinations()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            PadsView()
                .environmentObject(router)
                .navigationTitle("MidiPad")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarLeading) {
                        
                        Button {
                            
                            router.path.append(AppDestination.settings)
                            
                        } label: {
                            
                            Image(systemName: "gearshape")
                            
                        }
                        
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Button {
                            
                            router.path.append(AppDestination.addPad)
                            
                        } label: {
                            
                            Image(systemName: "plus")
                            
                        }
                        
                    }
                    
                }
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .settings:
                        SettingsView()
                    case .addPad:
                        PadEditorView(pad: nil)
                    case .editPad(let pad):
                        PadEditorView(pad: pad)
                    }
                }
            }
        }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    // 1. Create an in-memory only container for the Pad model
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pad.self, configurations: config)
    
    // 2. Seed the in-memory context using your existing seeder
    try? DatabaseSeeder.seed(context: container.mainContext)
    
    // 3. Return the view with the container and environment object attached
    return ContentView()
        .modelContainer(container)
        .environmentObject(MIDIManager())
}
