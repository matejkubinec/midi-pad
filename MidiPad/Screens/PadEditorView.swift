//
//  AddPadView.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//

import SwiftUI
import SwiftData

struct PadEditorView: View {
    let pad: Pad?

    @State private var name = ""
    @State private var ccNumber = 0
    @State private var value = 127

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            TextField("Name", text: $name)
            HStack() {
                HStack {
                    Text("CC")
                    Spacer()
                }
                    .frame(width: 56)
                TextField("CC Number", value: $ccNumber, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                Stepper("", value: $ccNumber, in: 0...127)
                    .labelsHidden()
            }
            HStack {
                HStack {
                    Text("Value")
                    Spacer()
                }
                    .frame(width: 56)
                TextField("Value", value: $value, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                Stepper("", value: $value, in: 0...127)
                    .labelsHidden()
            }
        }
        .navigationTitle(pad == nil ? "Add Pad" : "Edit Pad")

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                    dismiss()
                }
            }
        }
        .onAppear {
            if let pad {
                name = pad.name
                ccNumber = pad.ccNumber
                value = pad.value
            }
        }
    }

    private func save() {
        if (pad != nil) {
            return
        }

        let pad = Pad(
            id: pad?.id ?? UUID(),
            name: name,
            ccNumber: ccNumber,
            value: value
        )
        modelContext.insert(pad)
    }
}

#Preview {
    PadEditorView(pad: nil)
}

#Preview("Edit") {
    PadEditorView(pad: Pad(id: UUID(), name: "Pad #1", ccNumber: 55, value: 127))
}
