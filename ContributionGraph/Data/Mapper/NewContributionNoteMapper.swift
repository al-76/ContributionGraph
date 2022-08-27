//
//  NewContributionNoteMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import Foundation

struct CDContributionNoteMapper: Mapper {
    typealias Input = (StorageContext, NewContributionNote)

    func map(input: Input) -> Result<CDContributionNote, Error> {
        do {
            let data = try input.0.newData(CDContributionNote.self)
            data.created = Date.now
            data.note = input.1.note
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
}
