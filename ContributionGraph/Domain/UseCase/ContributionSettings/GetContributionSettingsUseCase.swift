//
//  GetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

/// @mockable
protocol GetContributionSettingsUseCase {
    func callAsFunction() -> AnyPublisher<ContributionSettings, Error>
}

final class DefaultGetContributionSettingsUseCase: GetContributionSettingsUseCase {
    func callAsFunction() -> AnyPublisher<ContributionSettings, Error> {
        Just(ContributionSettings(weekCount: 15))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
