//
//  Contribution+Init.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation

@testable import ContributionGraph

extension Contribution {
    init(days: Int, notes: [String]) {
        self.init(date: Date.neutral.days(ago: days), notes: notes, count: 2)
    }
}
