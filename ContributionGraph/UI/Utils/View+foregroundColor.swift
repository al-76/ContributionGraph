//
//  View+foregroundColor.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 25.06.2022.
//

import SwiftUI

extension View {
    func foregroundColor(light: Color, dark: Color) -> some View {
        foregroundColor(Color(light: light, dark: dark))
    }
}
