//
//  AddNoteUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Combine

final class AddNoteUseCase: UseCase {
    func execute(with input: NewContributionNote) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
