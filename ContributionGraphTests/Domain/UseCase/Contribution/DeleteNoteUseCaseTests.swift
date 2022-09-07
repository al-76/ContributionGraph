//
//  DeleteNoteUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 07.09.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class DeleteNoteUseCaseTests: XCTestCase {
    private let testDate = Date.now
    private let testNote = ContributionNote(id: UUID(), title: "", changed: Date.now, note: "test")
    private var useCase: DefaultDeleteNoteUseCase!

    override func setUp() {
        super.setUp()

        useCase = DefaultDeleteNoteUseCase()
    }

    func testExecute() throws {
        // Arrange

        // Act
        try awaitPublisher(useCase((testDate, testNote)))

        // Assert
    }
}
