//
//  ContributionMetricsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 14.09.2022.
//

import Foundation
import Combine

/// @mockable
protocol ContributionMetricsRepository {
    func read() -> AnyPublisher<ContributionMetrics, Error>
}
