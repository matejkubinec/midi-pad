//
//  BluetoothMIDIView.swift
//  MidiPad
//
//  Created by Matej Kubinec on 17/06/2026.
//

import SwiftUI
import CoreAudioKit

struct BluetoothMIDIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CABTMIDICentralViewController {
        return CABTMIDICentralViewController()
    }
    
    func updateUIViewController(_ uiViewController: CABTMIDICentralViewController, context: Context) {
        // No update needed for this component
    }
}
