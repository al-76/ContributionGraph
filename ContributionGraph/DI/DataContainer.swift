//
//  DataContainer.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 12.08.2022.
//

import Foundation
import Factory

final class DataContainer: SharedContainer {
    static let contributionRepository = Factory<ContributionRepository>(scope: .singleton) {
        DefaultContributionRepository(storage: PlatformContainer.storage(),
                                      mapper: DataContainer.contributionMapper())

    }

    static let contributionMapper = Factory(scope: .singleton) {
        AnyMapper(wrapped: ContributionMapper())
    }

    static let contributionDetailsMapper = Factory(scope: .singleton) {
        AnyMapper(wrapped: ContributionDetailsMapper())
    }

    static let dtoContributionNoteMapper = Factory(scope: .singleton) {
        AnyMapper(wrapped: DtoContributionNoteMapper())
    }

    static let contributionDetailsRepository =  Factory<ContributionDetailsRepository>(scope: .singleton) {
        DefaultContributionDetailsRepository(storage: PlatformContainer.storage(),
                                             mapper: DataContainer.contributionDetailsMapper(),
                                             dtoMapper: DataContainer.dtoContributionNoteMapper())
    }
}
