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
    func callAsFunction() -> AnyPublisher<ContributionMetrics, Error> {
        Just(ContributionMetrics(totalWeekCount: 15, totalContributionCount: 30))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
