//
//  XCTestCase+Await.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//
// Based on:
// https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
//

import Combine
import XCTest

enum TestAwaitError: Error {
    case unexpectedResult
}

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        let result = awaitAction(publisher, timeout: timeout)
        
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
    
    private func awaitAction<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval) -> Result<T.Output, T.Failure>? {
            var result: Result<T.Output, T.Failure>?
            let expectation = self.expectation(description: "Awaiting publisher")
            
            let cancellable = publisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        result = .failure(error)
                        expectation.fulfill()
                        break
                    case .finished:
                        break
                    }
                },
                receiveValue: { value in
                    result = .success(value)
                    expectation.fulfill()
                }
            )
            
            waitForExpectations(timeout: timeout)
            cancellable.cancel()
            
            return result
        }
}
