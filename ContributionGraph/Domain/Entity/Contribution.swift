//
//  Contribution.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation

struct Contribution: Equatable {
    let date: Date
    let count: Int
}

struct ContributionDetails: Equatable {
    let date: Date
    let notes: [ContributionNote]
}

struct ContributionNote: Hashable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let changed: Date
    let note: String
}
