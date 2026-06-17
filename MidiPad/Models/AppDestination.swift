//
//  AppDestination.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//


enum AppDestination: Hashable {
    case settings
    case addPad
    case editPad(Pad)
}
