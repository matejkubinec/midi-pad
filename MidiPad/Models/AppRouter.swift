//
//  AppRouter.swift
//  MidiPad
//
//  Created by Matej Kubinec on 18/06/2026.
//
import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    func goToSettings() {
        path.append(AppDestination.settings)
    }

    func addButton() {
        path.append(AppDestination.addPad)
    }

    func edit(_ pad: Pad) {
        path.append(AppDestination.editPad(pad))
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

