//
//  ContributionDetailsMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

struct ContributionDetailsMapper: Mapper {
    func map(input: CDContribution) -> ContributionDetails? {
        let notes = input.contributionNotesArray
        guard let date = input.date, !notes.isEmpty else { return nil }
        
        return ContributionDetails(date: date,
                                   notes: notes.map {
            ContributionNote(changed: $0.changed ?? Date.now, note: $0.note ?? "")
        })
    }
}
