//
//  LaunchSideEffect.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 09.08.2022.
//

import SwiftUI

struct LaunchSideEffect: View {
    init(sideEffect: () -> Void) {
        sideEffect()
    }
    
    var body: some View {
        EmptyView()
    }
}
