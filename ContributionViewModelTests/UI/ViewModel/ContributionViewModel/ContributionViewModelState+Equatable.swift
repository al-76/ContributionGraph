//
//  ContributionViewModelState+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.08.2022.
//

@testable import ContributionGraph

extension ContributionViewModel.State: Equatable {
    public static func == (lhs: ContributionViewModel.State, rhs: ContributionViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failure(_), .failure(_)):
            return true
        case let (.success(a), .success(b)):
            return a == b
        default:
            return false
        }
    }
}