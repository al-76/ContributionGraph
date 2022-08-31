//
//  ContributionViewModel.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

final class ContributionViewModel: ObservableObject {
    typealias State = ViewModelState<Data>
    
    struct Data {
        let items: [Int: Contribution]
        let details: ContributionDetails?
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
        
        func notes() -> [ContributionNote] {
            details?.notes ?? []
        }
        
        func notesCount(at day: Int) -> Int {
            items[day]?.count ?? 0
        }
        
        func date(at day: Int) -> String {
            (items[day]?.date ?? Date.neutral.days(ago: day))
                .format()
        }
        
        func update(details: ContributionDetails?) -> Data {
            Data(items: items,
                 details: details,
                 settings: settings,
                 metrics: metrics)
        }
    }
        
    @Published var state = State.loading
    
    private let getItems: AnyUseCase<Void, [Int: Contribution]>
    private let getDetails: AnyUseCase<Date, ContributionDetails?>
    private let getSettings: AnyUseCase<Void, ContributionSettings>
    private let setSettings: AnyUseCase<ContributionSettings, ContributionSettings>
    private let getMetrics: AnyUseCase<Void, ContributionMetrics>
    
    // TODO: add ContributionUseCase Factory
    init(getItems: AnyUseCase<Void, [Int: Contribution]>,
         getDetails: AnyUseCase<Date, ContributionDetails?>,
         getSettings: AnyUseCase<Void, ContributionSettings>,
         setSettings: AnyUseCase<ContributionSettings, ContributionSettings>,
         getMetrics: AnyUseCase<Void, ContributionMetrics>) {
        self.getItems = getItems
        self.getDetails = getDetails
        self.getSettings = getSettings
        self.setSettings = setSettings
        self.getMetrics = getMetrics
    }
    
    func set(settings: ContributionSettings) {
        state = .loading
        fetch(items: getItems(),
              details: getDetails(Date.neutral),
              settings: setSettings(settings),
              metrics: getMetrics())
            .assign(to: &$state)
    }
    
    func fetchContributionData(at day: Int = 0) {
        state = .loading
        fetch(items: getItems(),
              details: getDetails(Date.neutral.days(ago: day)),
              settings: getSettings(),
              metrics: getMetrics())
            .assign(to: &$state)
    }
    
    func fetchContribtuionDetails(at day: Int) {
        switch state {
        case .success(let data):
            getDetails(Date.neutral.days(ago: day))
                .map { .success(data.update(details: $0)) }
                .catch { Just(.failure($0)).eraseToAnyPublisher() }
                .receive(on: DispatchQueue.main)
                .print()
                .assign(to: &$state)
            
        default: // nothing to do here
            break
        }
    }
    
    private func fetch(items: AnyPublisher<[Int: Contribution], Error>,
                       details: AnyPublisher<ContributionDetails?, Error>,
                     settings: AnyPublisher<ContributionSettings, Error>,
                       metrics: AnyPublisher<ContributionMetrics, Error>) -> AnyPublisher<State, Never> {
        items.zip(details, settings, metrics)
            .map { .success(Data(items: $0,
                                 details: $1,
                                 settings: $2,
                                 metrics: $3)) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
