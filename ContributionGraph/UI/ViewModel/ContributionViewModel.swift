//
//  ContributionViewModel.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

final class ContributionViewModel: ObservableObject {
    enum State {
        case loading
        case failure(Error)
        case success(Data)
    }
    
    struct Data {
        let items: [Int: ContributionItem]
        let settings: ContributionSettings
        
        func set(weekCount: Int) -> ContributionSettings {
            ContributionSettings(weekCount: weekCount)
        }
        
        func weekCount() -> Int {
            settings.weekCount
        }
        
        func notes(at day: Int) -> [String] {
            items[day]?.notes ?? []
        }
        
        func notesCount(at day: Int) -> Int {
            items[day]?.notes.count ?? 0
        }
        
        func date(at day: Int) -> String {
            items[day]?.date.string() ?? Date.now.days(ago: day).string()
        }
    }
        
    @Published var state = State.loading
    
    private let getItemsUseCase: AnyUseCase<Void, [Int: ContributionItem]>
    private let getSettingsUseCase: AnyUseCase<Void, ContributionSettings>
    private let setSettingsUseCase: AnyUseCase<ContributionSettings, ContributionSettings>
    private var cancellable: AnyCancellable?
    
    init(getItemsUseCase: AnyUseCase<Void, [Int: ContributionItem]>,
         getSettingsUseCase: AnyUseCase<Void, ContributionSettings>,
         setSettingsUseCase: AnyUseCase<ContributionSettings, ContributionSettings>) {
        self.getItemsUseCase = getItemsUseCase
        self.getSettingsUseCase = getSettingsUseCase
        self.setSettingsUseCase = setSettingsUseCase
    }
    
    func set(settings: ContributionSettings) {
        state = .loading
        fetch(items: getItemsUseCase.execute(with: ()),
            settings: setSettingsUseCase.execute(with: settings))
            .assign(to: &$state)
    }
    
    func fetchContributionData() {
        state = .loading
        fetch(items: getItemsUseCase.execute(with: ()),
            settings: getSettingsUseCase.execute(with: ()))
            .assign(to: &$state)
    }
    
    private func fetch(items: AnyPublisher<[Int: ContributionItem], Error>,
                     settings: AnyPublisher<ContributionSettings, Error>) -> AnyPublisher<State, Never> {
        items.zip(settings)
            .map { State.success(Data(items: $0, settings: $1)) }
            .catch { Just(State.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
