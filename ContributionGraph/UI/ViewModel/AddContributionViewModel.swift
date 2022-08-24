//
//  AddContributionViewModel.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 08.08.2022.
//

import Combine
import Foundation

final class AddContributionViewModel: ObservableObject {
    enum State {
        case loading
        case failure(Error)
        case success(Bool)
    }
    
    @Published var state = State.success(false)
    
    private let addNoteUseCase: AnyUseCase<NewContributionNote, Void>
    
    init(addNoteUseCase: AnyUseCase<NewContributionNote, Void>) {
        self.addNoteUseCase = addNoteUseCase
    }
    
    func add(note: String, at day: Int) {
        state = .loading
        addNoteUseCase(NewContributionNote(day: day, note: note))
            .map { State.success(true) }
            .catch { Just(State.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}
