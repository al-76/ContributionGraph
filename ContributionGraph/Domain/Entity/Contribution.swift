//
//  Contribution.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation

struct Contribution {
    let date: Date
    let count: Int
}

struct ContributionDetails {
    let date: Date
    let notes: [ContributionNote]
}

struct ContributionNote {
    let id: UUID
    let title: String
    let changed: Date
    let note: String
}

extension ContributionNote: Hashable {}
extension ContributionNote: Identifiable {}
