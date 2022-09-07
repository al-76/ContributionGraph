//
//  ViewModelState+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

@testable import ContributionGraph
import Foundation

extension ViewModelState: Equatable where T: Equatable {
    public static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.failure(errorA as NSError),
                  .failure(errorB as NSError)):
            return errorA == errorB
        case let (.success(a), .success(b)):
            return a == b
        default:
            return false
        }
    }
}
