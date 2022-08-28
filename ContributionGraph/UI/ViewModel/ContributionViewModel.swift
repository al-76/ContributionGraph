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
        let items: [Int: Contribution]
        let settings: ContributionSettings
        let metrics: ContributionMetrics
        
        func set(weekCount: Int) -> ContributionSettings {
            ContributionSettings(weekCount: weekCount)
        }
        
        func totalWeekCount() -> Int {
            metrics.totalWeekCount
        }
        
        func totalContributionCount() -> Int {
            metrics.totalContributionCount
        }
        
        func weekCount() -> Int {
            settings.weekCount
        }
        
        func notes(at day: Int) -> [String] {
            items[day]?.notes ?? []
        }
        
        func notesCount(at day: Int) -> Int {
            items[day]?.count ?? 0
        }
        
        func date(at day: Int) -> String {
            items[day]?.date.string() ?? Date.neutral.days(ago: day).string()
        }
    }
        
    @Published var state = State.loading
    
    private let getItemsUseCase: AnyUseCase<Void, [Int: Contribution]>
    private let getSettingsUseCase: AnyUseCase<Void, ContributionSettings>
    private let setSettingsUseCase: AnyUseCase<ContributionSettings, ContributionSettings>
    private let getMetricsUseCase: AnyUseCase<Void, ContributionMetrics>
    
    // TODO: add ContributionUseCase Factory
    init(getItemsUseCase: AnyUseCase<Void, [Int: Contribution]>,
         getSettingsUseCase: AnyUseCase<Void, ContributionSettings>,
         setSettingsUseCase: AnyUseCase<ContributionSettings, ContributionSettings>,
         getMetricsUseCase: AnyUseCase<Void, ContributionMetrics>) {
        self.getItemsUseCase = getItemsUseCase
        self.getSettingsUseCase = getSettingsUseCase
        self.setSettingsUseCase = setSettingsUseCase
        self.getMetricsUseCase = getMetricsUseCase
    }
    
    func set(settings: ContributionSettings) {
        state = .loading
        fetch(items: getItemsUseCase(),
              settings: setSettingsUseCase(settings),
              metrics: getMetricsUseCase())
            .assign(to: &$state)
    }
    
    func fetchContributionData() {
        state = .loading
        fetch(items: getItemsUseCase(),
              settings: getSettingsUseCase(),
              metrics: getMetricsUseCase())
            .assign(to: &$state)
    }
    
    private func fetch(items: AnyPublisher<[Int: Contribution], Error>,
                     settings: AnyPublisher<ContributionSettings, Error>,
                       metrics: AnyPublisher<ContributionMetrics, Error>) -> AnyPublisher<State, Never> {
        items.zip(settings, metrics)
            .map { State.success(Data(items: $0, settings: $1, metrics: $2)) }
            .catch { Just(State.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
