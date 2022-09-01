//
//  MockAnyMapper.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

@testable import ContributionGraph

func mockAnyMapper<Input, Output>() -> AnyMapper<Input, Output> {
    AnyMapper(wrapped: MockMapper())
}

func mockAnyMapper<Input, Output>(_ mock: MockMapper<Input, Output>) -> AnyMapper<Input, Output> {
    AnyMapper(wrapped: mock)
}
