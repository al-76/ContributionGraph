//
//  ViewModelState+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

extension ViewModelState: Equatable where T: Equatable {
    internal static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failure, .failure):
            return true
        case let (.success(a), .success(b)):
            return a == b
        default:
            return false
        }
    }
}
