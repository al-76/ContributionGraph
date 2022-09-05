//
//  GetContributionDetailsUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation
import Combine

/// @mockable
protocol GetContributionDetailsUseCase {
    func callAsFunction(_ input: Date) -> AnyPublisher<ContributionDetails?, Error>
}

final class DefaultGetContributionDetailsUseCase: GetContributionDetailsUseCase {
    private let repository: ContributionDetailsRepository

    init(repository: ContributionDetailsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: Date) -> AnyPublisher<ContributionDetails?, Error> {
        repository.read(date: input)
    }
}
