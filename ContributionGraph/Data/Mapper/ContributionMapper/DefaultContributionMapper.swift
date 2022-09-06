//
//  DefaultContributionMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import Foundation

struct DefaultContributionMapper: ContributionMapper {
    func map(input: CDContribution) -> Contribution {
        Contribution(date: input.date ?? Date.neutral,
                     count: Int(input.count))
    }
}

extension CDContribution {
    var contributionNotesArray: [CDContributionNote] {
        (contributionNotes?.allObjects as? [CDContributionNote] ?? [])
            .sorted { $0.changed ?? Date.now > $1.changed ?? Date.now }
    }
}
