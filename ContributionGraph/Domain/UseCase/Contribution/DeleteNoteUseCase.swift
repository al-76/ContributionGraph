//
//  DeleteNoteUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 07.09.2022.
//

import Foundation
import Combine

/// @mockable(history: callAsFunction = true)
protocol DeleteNoteUseCase {
    func callAsFunction(_ input: (ContributionNote, Contribution)) -> AnyPublisher<Void, Error>
}

final class DefaultDeleteNoteUseCase: DeleteNoteUseCase {
    let repository: ContributionDetailsRepository

    init(repository: ContributionDetailsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: (ContributionNote, Contribution)) -> AnyPublisher<Void, Error> {
        repository.delete(input.0, to: input.1)
    }
}
