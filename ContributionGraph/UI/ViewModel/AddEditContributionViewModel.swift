//
//  AddEditContributionViewModel.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Combine
import Foundation

final class AddEditContributionViewModel: ObservableObject {
    typealias State = ViewModelState<Bool>

    @Published var state = State.success(false)

    struct Data {
        let day: Int
        let title: String
        let note: String
        let contributionNote: ContributionNote?
    }

    private let updateNote: any UseCase<(Date, ContributionNote), Void>

    init(updateNote: some UseCase<(Date, ContributionNote), Void>) {
        self.updateNote = updateNote
    }

    func set(data: Data) {
        state = .loading
        updateNote(getInput(from: data))
            .map { State.success(true) }
            .catch { Just(State.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

    private func getInput(from data: Data) -> (Date, ContributionNote) {
        let date = Date.neutral.days(ago: data.day)

        if let contributionNote = data.contributionNote {
            return (date, contributionNote.update(title: data.title,
                                                  note: data.note))
        }
        return (date, ContributionNote(id: UUID(),
                                       title: data.title,
                                       changed: Date.now,
                                       note: data.note))
    }
}

private extension ContributionNote {
    func update(title: String, note: String) -> ContributionNote {
        ContributionNote(id: id,
                         title: title,
                         changed: Date.now,
                         note: note)
    }
}
