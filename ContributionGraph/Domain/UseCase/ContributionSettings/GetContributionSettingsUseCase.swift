//
//  GetContributionSettingsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

final class GetContributionSettingsUseCase: UseCase {
    let repository: ContributionSettingsRepository

    init(repository: ContributionSettingsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: Void) -> AnyPublisher<ContributionSettings, Error> {
        repository.read()
    }
}
