//
//  DefaultContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

final class DefaultContributionRepository: ContributionRepository {
    private var dates = [
        ContributionItem(date: date(daysAgo: 0), notes: ["Test1", "Test2"]),
        ContributionItem(date: date(daysAgo: 1), notes: ["Test3", "Test4"]),
        ContributionItem(date: date(daysAgo: 2), notes: ["Test5"]),
        ContributionItem(date: date(daysAgo: 9), notes: ["Test7", "Test8"]),
        ContributionItem(date: date(daysAgo: 15), notes: ["Test9", "Test10", "Test11"])
    ]
    
    func read() -> AnyPublisher<[ContributionItem], Error> {
        Future { [weak self] promise in
            promise(.success(self?.dates ?? []))
        }.eraseToAnyPublisher()
    }
    
    func write(item: ContributionItem) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return promise(.success(())) }
            
            self.dates.append(item)
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    private static func date(daysAgo: Int) -> Date {
        Date.now.days(ago: daysAgo)
    }
}
