//
//  MockAnyMapper.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

@testable import ContributionGraph

func MockAnyMapper<Input, Output>() -> AnyMapper<Input, Output> {
    AnyMapper(wrapped: MockMapper())
}

func MockAnyMapper<Input, Output>(_ mock: MockMapper<Input, Output>) -> AnyMapper<Input, Output> {
    AnyMapper(wrapped: mock)
}
