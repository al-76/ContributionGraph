//
//  AddContributionViewModelState+Equatable.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 10.08.2022.
//

import Foundation

@testable import ContributionGraph

extension AddContributionViewModel.State: Equatable {
    public static func == (lhs: AddContributionViewModel.State, rhs: AddContributionViewModel.State) -> Bool {
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
