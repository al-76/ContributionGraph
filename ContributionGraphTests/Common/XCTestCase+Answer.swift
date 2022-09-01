//
//  XCTestCase+Answer.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 24.08.2022.
//

import XCTest
import Combine

extension XCTestCase {
    func successAnswer<T>(_ data: T) -> AnyPublisher<T, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func failAnswer<T>(_ error: Error = TestError.someError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    func failAnswer<T>(_ error: Error, _ type: T.Type) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    func noAnswer<T>() -> AnyPublisher<T, Error> {
        Empty<T, Error>()
            .eraseToAnyPublisher()
    }
}
