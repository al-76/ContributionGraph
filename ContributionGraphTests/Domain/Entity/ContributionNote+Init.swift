//
//  ContributionNote+Init.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 02.09.2022.
//

import Foundation

extension ContributionNote {
    init(_ data: String) {
        self.init(id: UUID(), title: data, changed: Date.now, note: data)
    }
}
