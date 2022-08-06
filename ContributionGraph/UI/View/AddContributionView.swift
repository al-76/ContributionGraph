//
//  AddContributionView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.07.2022.
//

import SwiftUI

struct AddContributionView: View {
//    private static let newCategoryValue = "New Category"
    
//    @State private var newCategory = ""
    @State private var newContribution = ""
//    @State private var selectedCategory = ""
//    @State private var testData = ["Test2", "Test", newCategoryValue]
    
    var body: some View {
        VStack {
//            Picker("Category", selection: $selectedCategory) {
//                ForEach(testData, id: \.self) {
//                    Text($0)
//                }
//            }
//            if selectedCategory == Self.newCategoryValue {
//                TextField("New Category", text: $newCategory)
//            }
//            Divider()
            TextField("What did you do?", text: $newContribution)
            Spacer()
        }.padding()
    }
}

struct AddContributionView_Previews: PreviewProvider {
    static var previews: some View {
        AddContributionView()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
