//
//  GetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

final class DefaultGetContributionSettingsUseCase: UseCase {
    func callAsFunction(_ input: Void) -> AnyPublisher<ContributionSettings, Error> {
        Just(ContributionSettings(weekCount: 15))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
