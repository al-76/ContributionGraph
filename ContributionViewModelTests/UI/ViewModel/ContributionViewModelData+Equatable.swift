//
//  ContributionViewModelData+Equatable.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.08.2022.
//

@testable import ContributionGraph

extension ContributionViewModel.Data: Equatable {
    public static func == (lhs: ContributionViewModel.Data, rhs: ContributionViewModel.Data) -> Bool {
        lhs.items == rhs.items && lhs.settings == rhs.settings
    }
}
