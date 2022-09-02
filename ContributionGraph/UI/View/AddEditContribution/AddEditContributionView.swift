//
//  AddEditContributionView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.07.2022.
//

import Factory
import SwiftUI

struct AddEditContributionView: View {
    private let day: Int
    private let contributionNote: ContributionNote?
    @Binding var isPresented: Bool
    @State private var title: String
    @State private var note: String

    @StateObject private var viewModel = UIContainer.addEditContributionViewModel()

    init(day: Int, contributionNote: ContributionNote?, isPresented: Binding<Bool>) {
        self.day = day
        self.contributionNote = contributionNote
        self._isPresented = isPresented
        self._title = State(initialValue: contributionNote?.title ?? "")
        self._note = State(initialValue: contributionNote?.note ?? "")
    }

    var body: some View {
        VStack {
            HStack {
                Text(header())
                    .font(.headline)
                Spacer()
                if isPresented {
                    doneButton()
                }
            }

            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")

            case .success(let submitted):
                if submitted {
                    LaunchSideEffect {
                        isPresented = false
                    }
                } else {
                    TextField("Title", text: $title)
                    TextEditor(text: $note)
                    Spacer()
                }

            case .failure(let error):
                ErrorView(error: error)
            }
        }
        .padding()
    }
}

// MARK: - Components
extension AddEditContributionView {
    private func header() -> String {
        "\((contributionNote == nil) ? "Add" : "Edit") contribution"
    }

    private func doneButton() -> some View {
        Button {
            viewModel.add(note: note, at: day)
        } label: {
            Label {
                Text("Done")
            } icon: {
                Image(systemName: "chevron.down.circle")
                    .foregroundColor(.green)
            }
        }
        .disabled(title.isEmpty)
    }
}

struct AddEditContributionView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditContributionView(day: 0,
                                contributionNote: nil,
                                isPresented: .constant(true))
        .preferredColorScheme(.light)
        .previewInterfaceOrientation(.portrait)
    }
}
