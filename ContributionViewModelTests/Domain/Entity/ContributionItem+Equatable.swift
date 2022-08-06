//
//  ContributionItem+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.08.2022.
//

@testable import ContributionGraph

extension ContributionItem: Equatable {
    public static func == (lhs: ContributionItem, rhs: ContributionItem) -> Bool {
        lhs.notes == rhs.notes && lhs.date == rhs.date
    }
}
