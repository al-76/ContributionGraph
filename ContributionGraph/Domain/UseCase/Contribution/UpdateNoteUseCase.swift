//
//  UpdateNoteUseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Foundation
import Combine

final class DefaultUpdateNoteUseCase: UseCase {
    let repository: ContributionDetailsRepository

    init(repository: ContributionDetailsRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: (Date, ContributionNote)) -> AnyPublisher<Void, Error> {
        repository.write(input.1, at: input.0)
    }
}
