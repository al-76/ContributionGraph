//
//  PlatformContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 26.08.2022.
//

import Foundation
import Factory

final class PlatformContainer: SharedContainer {
    static let storage = Factory<Storage>(scope: .singleton) {
        DefaultStorage(name: "ContributionModel")
    }
}
