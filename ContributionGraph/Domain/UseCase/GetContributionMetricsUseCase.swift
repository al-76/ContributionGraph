//
//  GetContributionMetricsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 07.08.2022.
//

import Combine

final class DefaultGetContributionMetricsUseCase: UseCase {
    let repository: ContributionMetricsRepository

    init(repository: ContributionMetricsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: Void) -> AnyPublisher<ContributionMetrics, Error> {
        repository.read()
    }
}
