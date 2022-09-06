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

struct DefaultContributionDetailsMapper: ContributionDetailsMapper {
    func map(input: CDContribution) -> ContributionDetails? {
        let notes = input.contributionNotesArray
        guard let date = input.date, !notes.isEmpty else { return nil }

        return ContributionDetails(date: date,
                                   notes: notes.map {
            ContributionNote(id: $0.id ?? UUID(),
                             title: $0.title ?? "",
                             changed: $0.changed ?? Date.now,
                             note: $0.note ?? "")
        })
    }
}
