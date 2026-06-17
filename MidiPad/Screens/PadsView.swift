//
//  PadsView.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//
import SwiftUI
import SwiftData

struct PadsView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var midi: MIDIManager
    @EnvironmentObject var router: AppRouter

    @Query(sort: \Pad.createdAt, order: .forward) private var pads: [Pad]
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]

    var body: some View {
        ScrollView {
                if pads.isEmpty {
                    ContentUnavailableView(
                        "No midi pads",
                        systemImage: "list.bullet.rectangle",
                        description: Text("You haven't added anything to your list yet.")
                    )
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(pads) { pad in
                            Button {
                                midi.sendCC(controller: UInt8(pad.ccNumber), value: UInt8(pad.value), channel: 0)
                            } label: {
                                Text(pad.name)
                                    .frame(maxWidth: .infinity, minHeight: 80)
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 8))
                            .contextMenu {
                                Button {
                                    router.edit(pad)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    modelContext.delete(pad)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
}
