//
//  SetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

final class SetContributionSettingsUseCase: UseCase {
    func execute(with input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        Just(input)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
