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
        GetContributionUseCase(repository: DataContainer.contributionRepository())
    }

    static let updateNoteUseCase = Factory {
        UpdateNoteUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    static let getDeleteNoteUseCase = Factory {
        DeleteNoteUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    // MARK: - Contribution Details
    static let getContributionDetailsUseCase = Factory {
        GetContributionDetailsUseCase(repository: DataContainer.contributionDetailsRepository())
    }

    // MARK: - Contribution Settings
    static let getContributionSettingsUseCase = Factory {
        GetContributionSettingsUseCase()
    }

    static let setContributionSettingsUseCase = Factory {
        SetContributionSettingsUseCase()
    }

    // MARK: - Metrics
    static let getContributionMetricsUseCase = Factory {
        GetContributionMetricsUseCase(repository: DataContainer.contributionMetricsRepository())
    }
}
