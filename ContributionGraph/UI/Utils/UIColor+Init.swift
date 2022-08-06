//
//  UIColor+Init.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 25.06.2022.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return light
            case .dark:
                return dark
            case .unspecified:
                fallthrough
            @unknown default:
                return light
            }
        }
    }
}
