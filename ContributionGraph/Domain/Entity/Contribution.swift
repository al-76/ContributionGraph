//
//  Contribution.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation

struct Contribution {
    let date: Date
    let notes: [String]
    let count: Int
}

struct NewContributionNote {
    let day: Int
    let note: String
}
