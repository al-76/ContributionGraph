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

    enum ViewModelError: Error {
        case noData
        case wrongIndex(index: Int)
    }

    struct Data: Equatable {
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
    }

    @Published var state = State.loading

    private let getItems: any UseCase<Void, [Int: Contribution]>
    private let getDetails: any UseCase<Date, ContributionDetails?>
    private let getSettings: GetContributionSettingsUseCase
    private let setSettings: SetContributionSettingsUseCase
    private let getMetrics: any UseCase<Void, ContributionMetrics>
    private let deleteNote: DeleteNoteUseCase

    // TODO: add ContributionUseCase Factory
    init(getItems: some UseCase<Void, [Int: Contribution]>,
         getDetails: some UseCase<Date, ContributionDetails?>,
         getSettings: GetContributionSettingsUseCase,
         setSettings: SetContributionSettingsUseCase,
         getMetrics: some UseCase<Void, ContributionMetrics>,
         deleteNote: DeleteNoteUseCase) {
        self.getItems = getItems
        self.getDetails = getDetails
        self.getSettings = getSettings
        self.setSettings = setSettings
        self.getMetrics = getMetrics
        self.deleteNote = deleteNote
    }

    func set(settings: ContributionSettings) {
        switch state {
        case .success(let data):
            fetch(items: getItems(),
                  details: getDetails(Date.neutral),
                  settings: setSettings(settings),
                  metrics: getMetrics(),
                  data: data)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        default: // nothing to do here
            break
        }
    }

    func set(selectedDay day: Int) {
        switch state {
        case .success(let data):
            state = .success(data.copy { $0.selectedDay = day })

        default: // nothing to do here
            break
        }
    }

    func set(editingNote note: ContributionNote?) {
        switch state {
        case .success(let data):
            state = .success(data.copy { $0.editingNote = note })

        default: // nothing to do here
            break
        }
    }

    func deleteDataNote(at index: Int) {
        switch state {
        case .success(let data):
            guard let details = data.details,
                  let contribution = data.items[data.selectedDay] else {
                state = .failure(ViewModelError.noData)
                break
            }
            guard index >= 0 && index < details.notes.count else {
                state = .failure(ViewModelError.wrongIndex(index: index))
                break
            }

            deleteNote((details.notes[index], contribution))
                .flatMap { [refreshData] in
                    refreshData(contribution.date, data) }
                .catch { Just(.failure($0)).eraseToAnyPublisher() }
                .receive(on: DispatchQueue.main)
                .assign(to: &$state)

        default: // nothing to do here
            break
        }
    }

    func fetchContributionData() {
        switch state {
        case .success(let data):
            fetchContributionDataAction(data)

        default:
            fetchContributionDataAction()
        }
    }

    func fetchContribtuionDetails() {
        switch state {
        case .success(let data):
            getDetails(Date.neutral.days(ago: data.selectedDay))
                .map { details in
                        .success(data.copy {
                            $0.details = details
                        }) }
                .catch { Just(.failure($0)).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .assign(to: &$state)

        default: // nothing to do here
            break
        }
    }

    // MARK: - Actions
    private func fetchContributionDataAction(_ data: Data? = nil) {
        refreshData(at: Date.neutral.days(ago: data?.selectedDay ?? 0),
                    with: data)
        .receive(on: DispatchQueue.main)
        .assign(to: &$state)
    }

    // MARK: - Helpers
    private func refreshData(at date: Date,
                             with data: Data?) -> AnyPublisher<State, Never> {
        fetch(items: getItems(),
              details: getDetails(date),
              settings: getSettings(),
              metrics: getMetrics(),
              data: data)
    }

    private func fetch(items: AnyPublisher<[Int: Contribution], Error>,
                       details: AnyPublisher<ContributionDetails?, Error>,
                       settings: AnyPublisher<ContributionSettings, Error>,
                       metrics: AnyPublisher<ContributionMetrics, Error>,
                       data: Data?) -> AnyPublisher<State, Never> {
        items.zip(details, settings, metrics)
            .map { .success(Data(items: $0,
                                 details: $1,
                                 settings: $2,
                                 metrics: $3,
                                 selectedDay: data?.selectedDay ?? 0,
                                 editingNote: data?.editingNote)) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}

// MARK: - Data copy
extension ContributionViewModel.Data {
    typealias OnCopy = (inout Builder) -> Void

    func copy(onCopy: OnCopy) -> ContributionViewModel.Data {
        var builder = Builder(items: items,
                              details: details,
                              settings: settings,
                              metrics: metrics,
                              selectedDay: selectedDay,
                              editingNote: editingNote)
        onCopy(&builder)
        return builder.object()
    }

    struct Builder {
        var items: [Int: Contribution]
        var details: ContributionDetails?
        var settings: ContributionSettings
        var metrics: ContributionMetrics
        var selectedDay: Int
        var editingNote: ContributionNote?

        fileprivate func object() -> ContributionViewModel.Data {
            ContributionViewModel.Data(items: items,
                                       details: details,
                                       settings: settings,
                                       metrics: metrics,
                                       selectedDay: selectedDay,
                                       editingNote: editingNote)
        }
    }
}
