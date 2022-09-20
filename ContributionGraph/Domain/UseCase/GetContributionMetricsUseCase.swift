//
//  GetContributionMetricsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 07.08.2022.
//

import Combine

/// @mockable
protocol GetContributionMetricsUseCase {
    func callAsFunction() -> AnyPublisher<ContributionMetrics, Error>
}

final class DefaultGetContributionMetricsUseCase: GetContributionMetricsUseCase {
    let repository: ContributionMetricsRepository

    init(repository: ContributionMetricsRepository) {
        self.repository = repository
    }

    func callAsFunction() -> AnyPublisher<ContributionMetrics, Error> {
        repository.read()
    }
}
