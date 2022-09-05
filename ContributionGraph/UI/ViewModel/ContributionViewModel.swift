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
        let selectedDay: Int
        let editingNote: ContributionNote?

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

        func copy(items: [Int: Contribution]? = nil,
                  details: ContributionDetails? = nil,
                  settings: ContributionSettings? = nil,
                  metrics: ContributionMetrics? = nil,
                  selectedDay: Int? = nil,
                  editingNote: ContributionNote? = nil) -> Data {
            Data(items: items ?? self.items,
                 details: details ?? self.details,
                 settings: settings ?? self.settings,
                 metrics: metrics ?? self.metrics,
                 selectedDay: selectedDay ?? self.selectedDay,
                 editingNote: editingNote ?? self.editingNote)
        }
    }

    @Published var state = State.loading

    private let getItems: GetContributionUseCase
    private let getDetails: GetContributionDetailsUseCase
    private let getSettings: GetContributionSettingsUseCase
    private let setSettings: SetContributionSettingsUseCase
    private let getMetrics: GetContributionMetricsUseCase

    // TODO: add ContributionUseCase Factory
    init(getItems: GetContributionUseCase,
         getDetails: GetContributionDetailsUseCase,
         getSettings: GetContributionSettingsUseCase,
         setSettings: SetContributionSettingsUseCase,
         getMetrics: GetContributionMetricsUseCase) {
        self.getItems = getItems
        self.getDetails = getDetails
        self.getSettings = getSettings
        self.setSettings = setSettings
        self.getMetrics = getMetrics
    }

    func set(settings: ContributionSettings) {
        switch state {
        case .success(let data):
            state = .loading
            setSettingsAction(settings, data)

        default: // nothing to do here
            break
        }
    }

    func set(selectedDay day: Int) {
        switch state {
        case .success(let data):
            state = .success(data.copy(selectedDay: day))

        default: // nothing to do here
            break
        }
    }

    func set(editingNote note: ContributionNote?) {
        switch state {
        case .success(let data):
            state = .success(data.copy(editingNote: note))

        default: // nothing to do here
            break
        }
    }

    func fetchContributionData() {
        switch state {
        case .success(let data):
            state = .loading
            fetchContributionDataAction(data)

        default:
            state = .loading
            fetchContributionDataAction()
        }
    }

    func fetchContribtuionDetails(at day: Int) {
        switch state {
        case .success(let data):
            getDetails(Date.neutral.days(ago: day))
                .map { .success(data.copy(details: $0)) }
                .catch { Just(.failure($0)).eraseToAnyPublisher() }
                .receive(on: DispatchQueue.main)
                .assign(to: &$state)

        default: // nothing to do here
            break
        }
    }

    private func fetchContributionDataAction(_ data: Data? = nil) {
        fetch(items: getItems(),
              details: getDetails(Date.neutral.days(ago: data?.selectedDay ?? 0)),
              settings: getSettings(),
              metrics: getMetrics(),
              data: data)
            .assign(to: &$state)
    }

    private func setSettingsAction(_ settings: ContributionSettings, _ data: Data?) {
        fetch(items: getItems(),
              details: getDetails(Date.neutral),
              settings: setSettings(settings),
              metrics: getMetrics(),
              data: data)
            .assign(to: &$state)
    }

    private func fetch(items: AnyPublisher<[Int: Contribution], Error>,
                       details: AnyPublisher<ContributionDetails?, Error>,
                       settings: AnyPublisher<ContributionSettings, Error>,
                       metrics: AnyPublisher<ContributionMetrics, Error>,
                       data: Data?) -> AnyPublisher<State, Never> {
        items.zip(details, settings, metrics)
            .map { .success(data?.copy(items: $0, details: $1, settings: $2, metrics: $3) ??
                            Data(items: $0, details: $1, settings: $2, metrics: $3,
                                 selectedDay: 0, editingNote: nil)) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
