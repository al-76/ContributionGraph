//
//  ContributionGraphUITests.swift
//  ContributionGraphUITests
//
//  Created by Vyacheslav Konopkin on 08.09.2022.
//

import XCTest

class ContributionGraphUITests: XCTestCase {
    let app: XCUIApplication = XCUIApplication()

    override func setUp() {
        super.setUp()

        app.launch()
    }

    func testSelectDay() {
        // Arrange
        let testDay = 20
        let selectedDay = app.otherElements["Day\(testDay)"]
        let initialHittable = selectedDay.isHittable

        // Act
        selectedDay.tap()

        // Assert
        XCTAssertEqual(app.staticTexts["SelectedDay"].label,
                        Date.neutral.days(ago: testDay).format())
        XCTAssertTrue(initialHittable)
    }

    func testScrollGraph() {
        // Arrange
        let selectedDay = app.otherElements["Day100"]
        let initialHittable = selectedDay.isHittable
        let graphGrid = app.otherElements["ContributionGraphGrid"]

        // Act
        graphGrid.swipeRight()

        // Assert
        XCTAssertFalse(initialHittable)
        XCTAssertTrue(selectedDay.isHittable)
    }

    func testAddEditRemoveContribution() {
        // Arrange
        let test = (title: "Title",
                    text: "TestNote",
                    edited: "Edited")
        let addButton = app.navigationBars["Items"].buttons["Add"]
        let titleText = app.textFields["Title"]
        let doneButton = app.buttons["Done"]
        let noteText = app.textViews["NoteText"]

        // Act
        // - Add
        addButton.tap()
        titleText.tap()
        titleText.typeText(test.title)
        noteText.tap()
        noteText.typeText(test.text)
        doneButton.tap()
        var item = app.staticTexts[contributionTitle(test.title)]
        let itemWasAdded = item.exists
        // - Edit
        item.tap()
        titleText.tap()
        titleText.typeText(test.edited)
        noteText.tap()
        noteText.typeText(test.edited)
        doneButton.tap()
        item = app.staticTexts[contributionTitle(test.title + test.edited)]
        let itemWasEdited = item.exists
        // - Remove
        item.swipeLeft()
        app.buttons["Delete"].tap()
        let itemWasRemoved = !item.exists

        // Assert
        XCTAssertTrue(itemWasAdded)
        XCTAssertTrue(itemWasEdited)
        XCTAssertTrue(itemWasRemoved)
    }

    private func contributionTitle(_ text: String) -> String {
        "\(Date.now.format())\n\(text)"
    }
}
