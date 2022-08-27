//
//  ContributionMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 17.08.2022.
//

import Foundation

struct ContributionMapper: Mapper {
    func map(input: CDContribution) -> Contribution {
        Contribution(date: input.date ?? Date.neutral,
                     notes: input.contributionNotesArray.compactMap { $0.note })
    }
}

struct CDContributionMapper: Mapper {
    typealias Input = (StorageContext, Contribution)

    func map(input: Input) -> Result<CDContribution, Error> {
        do {
            let newData = try input.0.newData(CDContribution.self)
            newData.date = input.1.date
            
            try input.1.notes.forEach {
                let newNote = try input.0.newData(CDContributionNote.self)
                newNote.created = Date.now
                newNote.note = $0
                newData.addToContributionNotes(newNote)
            }
            
            return .success(newData)
        } catch let error {
            return .failure(error)
        }
    }
}

struct CDContributionUpdateMapper: Mapper {
    typealias Input = (CDContribution, CDContributionNote)

    func map(input: Input) -> CDContribution {
        input.0.addToContributionNotes(input.1)
        return input.0
    }
}

private extension CDContribution {
    var contributionNotesArray: [CDContributionNote] {
        get {
            (contributionNotes?.allObjects as? [CDContributionNote] ?? [])
                .sorted { $0.created ?? Date.now > $1.created ?? Date.now }
        }
    }
}
