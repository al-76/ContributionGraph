//
//  SetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

/// @mockable
protocol SetContributionSettingsUseCase {
    func callAsFunction(_ input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error>
}

final class DefaultSetContributionSettingsUseCase: SetContributionSettingsUseCase {
    func callAsFunction(_ input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        Just(input)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
