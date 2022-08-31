//
//  ContributionItem+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.08.2022.
//

@testable import ContributionGraph

extension Contribution: Equatable {
    public static func == (lhs: Contribution, rhs: Contribution) -> Bool {
        lhs.count == rhs.count && lhs.date == rhs.date
    }
}
