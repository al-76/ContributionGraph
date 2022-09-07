//
//  DomainContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class DomainContainer: SharedContainer {
    // MARK: - Contribution
    static let getContributionUseCase = Factory {
        DefaultGetContributionUseCase(repository: DataContainer.contributionRepository())
    }

    static let updateNoteUseCase = Factory {
        DefaultUpdateNoteUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    static let getDeleteNoteUseCase = Factory {
        DefaultDeleteNoteUseCase()
    }

    // MARK: - Contribution Details
    static let getContributionDetailsUseCase = Factory {
        DefaultGetContributionDetailsUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    // MARK: - Contribution Settings
    static let getContributionSettingsUseCase = Factory {
        DefaultGetContributionSettingsUseCase()
    }

    static let setContributionSettingsUseCase = Factory {
        DefaultSetContributionSettingsUseCase()
    }

    // MARK: - Metrics
    static let getContributionMetricsUseCase = Factory {
        DefaultGetContributionMetricsUseCase()
    }
}
