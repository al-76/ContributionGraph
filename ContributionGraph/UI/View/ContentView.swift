//
//  ContentView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 20.06.2022.
//

import Factory
import SwiftUI

struct ContentView: View {
    var body: some View {
        ContributionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
