//
//  DeleteNoteUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 07.09.2022.
//

import Combine

final class DeleteNoteUseCase: UseCase {
    let repository: ContributionDetailsRepository

    init(repository: ContributionDetailsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: (ContributionNote, Contribution)) -> AnyPublisher<Void, Error> {
        repository.delete(input.0, to: input.1)
    }
}
