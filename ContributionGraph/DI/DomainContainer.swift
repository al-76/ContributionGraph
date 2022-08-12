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
        AnyUseCase(wrapped: GetContributionMetricsUseCase())
    }
    
    static let getContributionSettingsUseCase = Factory {
        AnyUseCase(wrapped: GetContributionSettingsUseCase())
    }
    
    static let setContributionSettingsUseCase = Factory {
        AnyUseCase(wrapped: SetContributionSettingsUseCase())
    }
    
    static let getContributionUseCase = Factory {
        AnyUseCase(wrapped: GetContributionUseCase(repository: DataContainer.contributionRepository()))
    }
    
    static let addNoteUseCase = Factory {
        AnyUseCase(wrapped: AddNoteUseCase())
    }
}
