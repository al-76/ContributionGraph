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
    func callAsFunction(_ input: (Date, ContributionNote)) -> AnyPublisher<Void, Error>
}

final class DefaultDeleteNoteUseCase: DeleteNoteUseCase {
    func callAsFunction(_ input: (Date, ContributionNote)) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
