//
//  DataContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class DataContainer: SharedContainer {
    static let contributionRepository = Factory<ContributionRepository> {
        DefaultContributionRepository()
    }
}
