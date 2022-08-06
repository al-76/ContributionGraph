//
//  Color+Init.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 25.06.2022.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}
