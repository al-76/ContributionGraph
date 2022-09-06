//
//  ContributionMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 17.08.2022.
//

import Foundation

/// @mockable
protocol ContributionMapper {
    func map(input: CDContribution) -> Contribution
}
