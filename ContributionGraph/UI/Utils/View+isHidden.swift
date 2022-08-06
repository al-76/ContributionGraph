//
//  View+isHidden.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import SwiftUI

extension View {
    func isHidden(_ value: Bool) -> some View {
        opacity(value ? 0.0 : 1.0)
    }
}

extension View {
    @ViewBuilder
    func isSelected(_ value: Bool) -> some View {
        if value {
            border(.green, width: 2.0)
        }
    }
}
