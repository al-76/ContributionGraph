//
//  ContributionDetailsMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

/// @mockable
protocol ContributionDetailsMapper {
    func map(input: CDContribution) -> ContributionDetails?
}
