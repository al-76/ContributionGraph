//
//  DefaultContributionMetricsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 14.09.2022.
//

import Foundation
import Combine

final class DefaultContributionMetricsRepository: ContributionMetricsRepository {
    typealias ContributionMetricsMapper = Mapper<(Int, [CDContribution]),
                                                 ContributionMetrics>

    private let storage: Storage
    private let mapper: any ContributionMetricsMapper

    init(storage: Storage, mapper: some ContributionMetricsMapper) {
        self.storage = storage
        self.mapper = mapper
    }

    func read() -> AnyPublisher<ContributionMetrics, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(ContributionMetrics(totalWeekCount: 0,
                                                     totalContributionCount: 0)))
                return
            }

            self.storage.count(predicate: nil,
                               CDContributionNote.self) { result in
                // Total contribution count
                switch result {
                case .success(let count):
                    self.storage.fetch(predicate: self.predicateFirstLast(),
                                       CDContribution.self) { result in
                        // Total week count
                        switch result {
                        case .success(let data):
                            let metrics = self.mapper.map(input: (count, data.items))
                            promise(.success(metrics))

                        case .failure(let error):
                            promise(.failure(error))
                        }
                    }

                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func predicateFirstLast() -> NSPredicate {
        NSPredicate(format: "date == max(date) OR date == min(date)")
    }
}
