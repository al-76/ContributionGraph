//
//  ContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import Combine

protocol ContributionRepository {
    func read() -> AnyPublisher<[Int: ContributionItem], Error>
    func write(item: ContributionItem) -> AnyPublisher<Void, Error>
}
