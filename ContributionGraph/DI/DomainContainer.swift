//
//  DomainContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class DomainContainer: SharedContainer {
    static let getContributionMetricsUseCase = Factory {
        DefaultGetContributionMetricsUseCase()
    }

    static let getContributionSettingsUseCase = Factory {
        DefaultGetContributionSettingsUseCase()
    }

    static let setContributionSettingsUseCase = Factory {
        DefaultSetContributionSettingsUseCase()
    }

    static let getContributionUseCase = Factory {
        DefaultGetContributionUseCase(repository: DataContainer.contributionRepository())
    }

    static let updateNoteUseCase = Factory {
        DefaultUpdateNoteUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    static let getContributionDetailsUseCase = Factory {
        DefaultGetContributionDetailsUseCase(repository: DataContainer.contributionDetailsRepository())
    }
}
