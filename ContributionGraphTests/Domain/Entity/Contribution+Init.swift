//
//  Contribution+Init.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation

extension Contribution {
    init(days: Int) {
        self.init(date: Date.neutral.days(ago: days), count: 2)
    }
}
