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
        XCTAssertEqual(app.staticTexts["SelectedDayText"].label,
                        Date.neutral.days(ago: testDay).format())
        XCTAssertTrue(initialHittable)
    }

    func testScrollGraph() {
        // Arrange
        let selectedDay = app.otherElements["Day80"]
        let initialHittable = selectedDay.isHittable
        let graphGrid = app.scrollViews["ContributionGraphGrid"]

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
        let itemWasAdded = item.waitForExistence(timeout: 1)
        // - Edit
        item.tap()
        titleText.tap()
        titleText.typeText(test.edited)
        noteText.tap()
        noteText.typeText(test.edited)
        doneButton.tap()
        item = app.staticTexts[contributionTitle(test.title + test.edited)]
        let itemWasEdited = item.waitForExistence(timeout: 1)
        // - Delete
        item.swipeLeft()
        app.buttons["Delete"].tap()
        let itemWasRemoved = !item.waitForExistence(timeout: 1)

        // Assert
        XCTAssertTrue(itemWasAdded)
        XCTAssertTrue(itemWasEdited)
        XCTAssertTrue(itemWasRemoved)
    }

    func testContributionCount() {
        // Arrange
        let testTitle = "Test"
        let addButton = app.navigationBars["Items"].buttons["Add"]
        let titleText = app.textFields["Title"]
        let doneButton = app.buttons["Done"]
        let contributionText = app.staticTexts["ContributionsCountText"]
        let initialContributions = contributionText.label.parseInt()

        // Act
        // - Add
        addButton.tap()
        titleText.tap()
        titleText.typeText(testTitle)
        doneButton.tap()
        let afterAddContributions = contributionText.label.parseInt()
        // - Delete
        let item = app.staticTexts[contributionTitle(testTitle)]
        item.swipeLeft()
        app.buttons["Delete"].tap()
        let afterDeleteContributions = contributionText.label.parseInt()

        // Assert
        XCTAssertEqual(afterAddContributions, initialContributions + 1)
        XCTAssertEqual(afterDeleteContributions, initialContributions)
    }

    func testWeeksCount() {
        // Arrange
        let test = (day: 14,
                    weeks: 2,
                    title: "Test")
        let addButton = app.navigationBars["Items"].buttons["Add"]
        let titleText = app.textFields["Title"]
        let doneButton = app.buttons["Done"]
        let weeksText = app.staticTexts["TotalWeekCountText"]
        let initialWeeks = weeksText.label.parseInt()

        // Act
        app.otherElements["Day14"].tap()
        // - Add
        addButton.tap()
        titleText.tap()
        titleText.typeText(test.title)
        doneButton.tap()
        let afterAddWeeks = weeksText.label.parseInt()
        // - Delete
        let item = app.staticTexts[contributionTitle(test.title)]
        item.swipeLeft()
        app.buttons["Delete"].tap()
        let afterDeleteWeeks = weeksText.label.parseInt()

        // Assert
        XCTAssertEqual(initialWeeks, 0)
        XCTAssertEqual(afterAddWeeks, test.weeks)
        XCTAssertEqual(afterDeleteWeeks, 0)
    }

    private func contributionTitle(_ text: String) -> String {
        "\(Date.now.format())\n\(text)"
    }
}

extension String {
    func parseInt() -> Int {
        let value = components(separatedBy:
                                        CharacterSet.decimalDigits.inverted)
            .joined() as String
        return Int(value) ?? -1
    }
}
