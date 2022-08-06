//
//  View+Alert.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation
import SwiftUI

public struct ViewError: Identifiable {
    private let error: Error
    
    public var id: String { self.localizedDescription }
    public var localizedDescription: String { self.error.localizedDescription }
    
    init(_ error: Error) {
        self.error = error
    }
}

extension ViewError: Error {}

extension View {
    public func alertError(error: Binding<ViewError?>) -> some View {
        alert(item: error, content: { error in
            Alert(title: Text("Error"),
                  message: Text(error.localizedDescription),
                  dismissButton: .default(Text("OK")))
        })
    }
}
