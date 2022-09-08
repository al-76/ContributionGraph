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

/// @mockable(history: map = true)
protocol DtoContributionMapper {
    typealias Input = (CDContribution,
                       Contribution)

    func map(input: Input) -> CDContribution
}

struct DefaultContributionMapper: ContributionMapper {
    func map(input: CDContribution) -> Contribution {
        Contribution(date: input.date ?? Date.neutral,
                     count: Int(input.count))
    }
}

struct DefaultDtoContributionMapper: DtoContributionMapper {
    func map(input: Input) -> CDContribution {
        let dtoContribution = input.0
        let contribution = input.1

        dtoContribution.date = contribution.date
        dtoContribution.count = Int32(contribution.count)

        return dtoContribution
    }
}

extension CDContribution {
    var contributionNotesArray: [CDContributionNote] {
        (contributionNotes?.allObjects as? [CDContributionNote] ?? [])
            .sorted { $0.changed ?? Date.now > $1.changed ?? Date.now }
    }
}
