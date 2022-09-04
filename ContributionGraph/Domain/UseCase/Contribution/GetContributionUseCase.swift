//
//  GetContributionUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine
import Foundation

/// @mockable
protocol GetContributionUseCase {
    func callAsFunction() -> AnyPublisher<[Int: Contribution], Error>
}

final class DefaultGetContributionUseCase: GetContributionUseCase {
    private let repository: ContributionRepository

    init(repository: ContributionRepository) {
        self.repository = repository
    }

    func callAsFunction() -> AnyPublisher<[Int: Contribution], Error> {
        repository.read().map { items in
            items.reduce(into: [Int: Contribution]()) {
                $0[Date.neutral.days(to: $1.date)] = $1
            }
        }
        .eraseToAnyPublisher()
    }
}
