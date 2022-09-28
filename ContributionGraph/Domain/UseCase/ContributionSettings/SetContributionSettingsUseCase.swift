//
//  SetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

final class SetContributionSettingsUseCase: UseCase {
    let repository: ContributionSettingsRepository

    init(repository: ContributionSettingsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        repository
            .write(settings: input)
            .flatMap { [weak self] in
                self?.repository.read() ?? Just(input)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
