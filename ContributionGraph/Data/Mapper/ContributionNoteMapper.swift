//
//  ContributionNoteMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

struct DtoContributionNoteMapper: Mapper {
    typealias Input = (Date,
                       ContributionNote,
                       CDContribution?,
                       StorageContext)

    func map(input: Input) -> Result<CDContributionNote, Error> {
        do {
            // Create DTO note
            let context = input.3
            let dtoNote = try context.newData(CDContributionNote.self)
            let note = input.1
            dtoNote.id = note.id
            dtoNote.title = note.title
            dtoNote.changed = note.changed
            dtoNote.note = note.note

            if let dtoContribution = input.2 {
                // Update exist contribution
                dtoContribution.addToContributionNotes(dtoNote)
                dtoContribution.count += 1
            } else {
                // Create new contribution
                let dtoContribution = try context.newData(CDContribution.self)
                dtoContribution.date = input.0
                dtoContribution.addToContributionNotes(dtoNote)
                dtoContribution.count = 1
            }

            return .success(dtoNote)
        } catch let error {
            return .failure(error)
        }
    }
}
