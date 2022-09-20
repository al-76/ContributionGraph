//
//  DefaultContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

final class DefaultContributionRepository: ContributionRepository {
    private let storage: Storage
    private let mapper: ContributionMapper

    init(storage: Storage, mapper: ContributionMapper) {
        self.storage = storage
        self.mapper = mapper
    }

    func read() -> AnyPublisher<[Contribution], Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success([]))
                return
            }

            self.storage
                .fetch(predicate: nil, CDContribution.self) { result in
                    switch result {
                    case .success(let data):
                        promise(.success(data.items
                            .map {
                                self.mapper.map(input: $0)
                            }))

                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
