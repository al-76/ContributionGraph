//
//  GetContributionUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Foundation
import Combine

final class DefaultGetContributionUseCase: UseCase {
    private let repository: ContributionRepository

    init(repository: ContributionRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: Void) -> AnyPublisher<[Int: Contribution], Error> {
        repository.read().map { items in
            items.reduce(into: [Int: Contribution]()) {
                $0[Date.neutral.days(to: $1.date)] = $1
            }
        }
        .eraseToAnyPublisher()
    }
}
