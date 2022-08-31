//
//  AddContributionViewModel.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Combine
import Foundation

final class AddContributionViewModel: ObservableObject {
    typealias State = ViewModelState<Bool>
    typealias AddNoteUseCase = AnyUseCase<(Date, ContributionNote), Void>
    
    @Published var state = State.success(false)
    
    private let addNote: AddNoteUseCase
    
    init(addNote: AddNoteUseCase) {
        self.addNote = addNote
    }
    
    func add(note: String, at day: Int) {
        state = .loading
        addNote((Date.neutral.days(ago: day), ContributionNote(changed: Date.now, note: note)))
            .map { State.success(true) }
            .catch { Just(State.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}
