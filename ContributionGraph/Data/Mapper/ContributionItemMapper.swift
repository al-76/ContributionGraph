//
//  ContributionItemMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 17.08.2022.
//

import Foundation

struct ContributionItemMapper: Mapper {
    func map(input: CDContributionEntity) -> ContributionItem {
        ContributionItem(date: input.date ?? Date.now,
                         notes: input.notes)
    }
}

private extension CDContributionEntity {
    var notes: [String] {
        get {
            (contributionNotes?.allObjects as? [String]) ?? []
        }
    }
}
