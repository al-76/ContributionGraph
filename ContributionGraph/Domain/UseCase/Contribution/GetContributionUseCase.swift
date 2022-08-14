//
//  GetContributionUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine
import Foundation

final class GetContributionUseCase: UseCase {
    private let repository: ContributionRepository
    
    init(repository: ContributionRepository) {
        self.repository = repository
    }
    
    func execute(with input: Void) -> AnyPublisher<[Int: ContributionItem], Error> {
        repository.read().map { items in
            items.reduce(into: [Int: ContributionItem]()) {
                $0[Date.now.days(to: $1.date)] = $1
            }
        }
        .eraseToAnyPublisher()
    }
    
    private static func date(daysAgo: Int) -> Date {
        Date.now.days(ago: daysAgo)
    }
}
