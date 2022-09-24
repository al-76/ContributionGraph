//
//  UseCaseMock.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 24.09.2022.
//

import Foundation
import Combine

@testable import ContributionGraph

final class UseCaseMock<Input, Output>: UseCase {
    init() { }

    private(set) var callAsFunctionCallCount = 0

    var callAsFunctionHandler: ((Input) -> (AnyPublisher<Output, Error>))?

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error> {
        callAsFunctionCallCount += 1

        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler(input)
        }

        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
    }
}

extension UseCaseMock where Input == Void {
    func callAsFunction() -> AnyPublisher<Output, Error> {
        callAsFunction(())
    }
}
