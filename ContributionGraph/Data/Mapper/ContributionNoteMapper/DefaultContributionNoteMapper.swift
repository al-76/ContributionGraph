//
//  DefaultContributionNoteMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import Foundation

struct DefaultDtoContributionNoteMapper: DtoContributionNoteMapper {
    func map(input: Input) -> Result<CDContributionNote, Error> {
        do {
            // Create DTO note
            let context = input.3
            let note = input.1
            if let dtoContribution = input.2 {
                // Update exist contribution
                if let dtoNote = dtoContribution.contributionNote(by: note.id) {
                    // Update exist note
                    dtoNote.update(from: note)

                    return .success(dtoNote)
                } else {
                    // Add new note
                    let dtoNote = try context.newData(CDContributionNote.self)
                    dtoContribution.addNewContribution(note, dtoNote)

                    return .success(dtoNote)
                }
            } else {
                // Create new contribution
                let dtoContribution = try context.newData(CDContribution.self)
                dtoContribution.date = input.0
                let dtoNote = try context.newData(CDContributionNote.self)
                dtoContribution.addNewContribution(note, dtoNote)

                return .success(dtoNote)
            }

        } catch let error {
            return .failure(error)
        }
    }
}

extension CDContribution {
    func contributionNote(by id: UUID) -> CDContributionNote? {
        let predicate = NSPredicate(format: "id=%@", id as NSUUID)
        let filtered = contributionNotes?
            .filtered(using: predicate)
        return filtered?
            .first as? CDContributionNote
    }

    func addNewContribution(_ note: ContributionNote, _ dtoNote: CDContributionNote) {
        dtoNote.update(from: note)
        addToContributionNotes(dtoNote)
        count += 1
    }
}

extension CDContributionNote {
    func update(from contributionNote: ContributionNote) {
        id = contributionNote.id
        title = contributionNote.title
        changed = contributionNote.changed
        note = contributionNote.note
    }
}
