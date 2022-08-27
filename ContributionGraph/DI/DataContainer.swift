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
                                      contributionMapper: DataContainer.contributionMapper(),
                                      dtoContributionMapper: DataContainer.dtoContributionMapper(),
                                      dtoContributionUpdateMapper: DataContainer.dtoContributionUpdateMapper(),
                                      contributionNoteMapper: DataContainer.contributionNoteMapper())
                                      
    }
    
    static let contributionMapper = Factory<AnyMapper<CDContribution, Contribution>>(scope: .singleton) {
        AnyMapper(wrapped: ContributionMapper())
    }
    
    static let dtoContributionMapper = Factory<AnyMapper<(StorageContext, Contribution), CDContributionMapper.Output>>(scope: .singleton) {
        AnyMapper(wrapped: CDContributionMapper())
    }
    
    static let dtoContributionUpdateMapper = Factory<AnyMapper<(CDContribution, CDContributionNote), CDContribution>>(scope: .singleton) {
        AnyMapper(wrapped: CDContributionUpdateMapper())
    }
    
    static let contributionNoteMapper = Factory<AnyMapper<(StorageContext, NewContributionNote), CDContributionNoteMapper.Output>>(scope: .singleton) {
        AnyMapper(wrapped: CDContributionNoteMapper())
    }
}
