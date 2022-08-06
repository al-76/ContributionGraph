//
//  GetContributionUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

final class GetContributionUseCase: UseCase {
    private let repository: ContributionRepository
    
    init(repository: ContributionRepository) {
        self.repository = repository
    }
    
    func execute(with input: Void) -> AnyPublisher<[Int: ContributionItem], Error> {
        repository.read()
    }
}
