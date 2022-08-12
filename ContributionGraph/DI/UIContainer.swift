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
        ContributionViewModel(getItemsUseCase: DomainContainer.getContributionUseCase(),
                              getSettingsUseCase: DomainContainer.getContributionSettingsUseCase(),
                              setSettingsUseCase: DomainContainer.setContributionSettingsUseCase(),
                              getMetricsUseCase: DomainContainer.getContributionMetricsUseCase())
    }
    
    static let addContributionViewModel = Factory(scope: .shared) {
        AddContributionViewModel(addNoteUseCase: DomainContainer.addNoteUseCase())
    }
}
