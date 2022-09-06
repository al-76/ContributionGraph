//
//  ContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import Combine

/// @mockable
protocol ContributionRepository {
    func read() -> AnyPublisher<[Contribution], Error>
}
