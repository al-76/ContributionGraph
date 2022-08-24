//
//  GetContributionMetricsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 07.08.2022.
//

import Combine

final class GetContributionMetricsUseCase: UseCase {
    func callAsFunction(_ input: Void) -> AnyPublisher<ContributionMetrics, Error> {
        Just(ContributionMetrics(totalWeekCount: 15, totalContributionCount: 30))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
