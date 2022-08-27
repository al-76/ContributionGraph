//
//  AddNoteUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Combine

final class AddNoteUseCase: UseCase {
    let repository: ContributionRepository
    
    init(repository: ContributionRepository) {
        self.repository = repository
    }
    
    func callAsFunction(_ input: NewContributionNote) -> AnyPublisher<Void, Error> {
        repository.write(note: input)
    }
}
