//
//  DataContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class DataContainer: SharedContainer {
    // MARK: - Contribution Repository
    static let contributionMapper = Factory(scope: .singleton) {
        DefaultContributionMapper()
    }

    static let contributionRepository = Factory<ContributionRepository>(scope: .singleton) {
        DefaultContributionRepository(storage: PlatformContainer.storage(),
                                      mapper: DataContainer.contributionMapper())

    }

    // MARK: - Contribution Details Repository
    static let contributionDetailsMapper = Factory(scope: .singleton) {
        DefaultContributionDetailsMapper()
    }

    static let dtoContributionNoteMapper = Factory(scope: .singleton) {
        DtoContributionNoteMapper()
    }

    static let dtoContributionMapper = Factory(scope: .singleton) {
        DefaultDtoContributionMapper()
    }

    static let contributionDetailsRepository =  Factory<ContributionDetailsRepository>(scope: .singleton) {
        DefaultContributionDetailsRepository(storage: PlatformContainer.storage(),
                                             detailsMapper: DataContainer.contributionDetailsMapper(),
                                             dtoNoteMapper: DataContainer.dtoContributionNoteMapper(),
                                             dtoContributionMapper: DataContainer.dtoContributionMapper())
    }

    // MARK: - Contribution Metrics Repository
    static let contributionMetricsMapper = Factory(scope: .singleton) {
        DefaultContributionMetricsMapper()
    }

    static let contributionMetricsRepository = Factory<ContributionMetricsRepository>(scope: .singleton) {
        DefaultContributionMetricsRepository(storage: PlatformContainer.storage(),
                                             mapper: DataContainer.contributionMetricsMapper())
    }
}
