//
//  UIContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class UIContainer: SharedContainer {
    static let contributionViewModel = Factory(scope: .shared) {
        ContributionViewModel(getItems: DomainContainer.getContributionUseCase(),
                              getDetails: DomainContainer.getContributionDetailsUseCase(),
                              getSettings: DomainContainer.getContributionSettingsUseCase(),
                              setSettings: DomainContainer.setContributionSettingsUseCase(),
                              getMetrics: DomainContainer.getContributionMetricsUseCase())
    }

    static let addContributionViewModel = Factory(scope: .shared) {
        AddContributionViewModel(addNote: DomainContainer.addNoteUseCase())
    }
}
