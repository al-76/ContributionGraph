//
//  ContributionMetricsMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 14.09.2022.
//

import Foundation

struct ContributionMetricsMapper: Mapper {
    typealias Input = (Int, [CDContribution])

    func map(input: Input) -> ContributionMetrics {
        let contributionCount = input.0
        let dtoContributions = input.1
        let firstDate = dtoContributions.first?.date ?? Date.now
        var lastDate = dtoContributions.last?.date ?? Date.now
        lastDate = (firstDate == lastDate) ? Date.now : lastDate
        return ContributionMetrics(totalWeekCount: firstDate.weeks(to: lastDate),
                                   totalContributionCount: Int(contributionCount))
    }
}
