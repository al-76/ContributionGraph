//
//  ContributionSettings+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.08.2022.
//

@testable import ContributionGraph

extension ContributionSettings: Equatable {
    public static func == (lhs: ContributionSettings, rhs: ContributionSettings) -> Bool {
        lhs.weekCount == rhs.weekCount
    }
}
