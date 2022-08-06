//
//  DefaultContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

struct DefaultContributionRepository: ContributionRepository {
    private let dates = [
        ContributionItem(date: date(daysAgo: 0), notes: ["Test1", "Test2"]),
        ContributionItem(date: date(daysAgo: 1), notes: ["Test3", "Test4"]),
        ContributionItem(date: date(daysAgo: 2), notes: ["Test5"]),
        ContributionItem(date: date(daysAgo: 9), notes: ["Test7", "Test8"]),
        ContributionItem(date: date(daysAgo: 15), notes: ["Test9", "Test10", "Test11"])
    ]
    
    func read() -> AnyPublisher<[Int: ContributionItem], Error> {
        Future { promise in
            let data = dates.reduce(into: [Int: ContributionItem]()) {
                $0[Date.now.days(to: $1.date)] = $1
            }
            promise(.success(data))
        }.eraseToAnyPublisher()
    }
    
    private static func date(daysAgo: Int) -> Date {
        Date.now.days(ago: daysAgo)
    }
}
