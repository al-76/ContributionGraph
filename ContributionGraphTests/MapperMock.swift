//
//  MapperMock.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 25.09.2022.
//

import Foundation

@testable import ContributionGraph

final class MapperMock<Input, Output>: Mapper {
    init() {}

    private(set) var mapCallCount = 0
    var mapArgValues = [Input]()
    var mapHandler: ((Input) -> Output)?

    func map(input: Input) -> Output {
        mapCallCount += 1
        mapArgValues.append(input)

        if let mapHandler = mapHandler {
            return mapHandler(input)
        }

        fatalError("mapHandler returns can't have a default value thus its handler must be set")
    }
}
