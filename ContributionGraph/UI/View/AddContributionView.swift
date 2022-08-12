//
//  AddContributionView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.07.2022.
//

import Factory
import SwiftUI

struct AddContributionView: View {
    let day: Int
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel = UIContainer.addContributionViewModel()
    @State private var newContribution = ""
    
//    private static let newCategoryValue = "New Category"
    
//    @State private var newCategory = ""

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
            
            Text("Add contribution").font(.headline)
            
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")

            case .success(let submitted):
                if submitted {
                    LaunchSideEffect {
                        isPresented = false
                    }
                } else {
                    TextField("What did you do?", text: $newContribution)
                        .onSubmit {
                            viewModel.add(note: newContribution, at: day)
                        }
                    Spacer()
                }

            case .failure(let error):
                Label {
                    Text("Error: \(error.localizedDescription)")
                } icon: {
                    Image(systemName: "xmark.app")
                            .foregroundColor(Color.red)
                }
            }
        }
        .padding()
    }
}

struct AddContributionView_Previews: PreviewProvider {
    static var previews: some View {
        AddContributionView(day: 0, isPresented: .constant(true))
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
