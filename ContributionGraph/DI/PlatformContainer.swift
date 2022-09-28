//
//  PlatformContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 26.08.2022.
//

import Foundation
import Factory

final class PlatformContainer: SharedContainer {
    static let contributionStorage = Factory(scope: .singleton) {
        DefaultStorage(name: "ContributionModel")
    }

    static let settingsStorage = Factory(scope: .singleton) {
        DefaultStorage(name: "SettingsModel")
    }
}
