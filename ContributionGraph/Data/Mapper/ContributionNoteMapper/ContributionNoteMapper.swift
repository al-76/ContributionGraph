//
//  ContributionNoteMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 30.08.2022.
//

import Foundation

/// @mockable(history: map = true)
protocol DtoContributionNoteMapper {
    typealias Input = (Date,
                       ContributionNote,
                       CDContribution?,
                       StorageContext)

    func map(input: Input) -> Result<CDContributionNote, Error>
}
