//
//  DefaultContributionSettingsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.09.2022.
//

import Foundation
import Combine

final class DefaultContributionSettingsRepository: ContributionSettingsRepository {
    typealias SettingsMapper = Mapper<CDContributionSettings?,
                                        ContributionSettings>
    typealias DtoSettingsMapper = Mapper<(ContributionSettings,
                                          CDContributionSettings?,
                                          StorageContext),
                                         Result<CDContributionSettings, Error>>

    private let storage: Storage
    private let mapper: any SettingsMapper
    private let dtoMapper: any DtoSettingsMapper

    init(storage: Storage,
         mapper: some SettingsMapper,
         dtoMapper: some DtoSettingsMapper) {
        self.storage = storage
        self.mapper = mapper
        self.dtoMapper = dtoMapper
    }

    func read() -> AnyPublisher<ContributionSettings, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(ContributionSettings(weekCount: 0)))
                return
            }

            self.storage.fetch(predicate: nil,
                               CDContributionSettings.self) { result in
                switch result {
                case .success(let data):
                    promise(.success(self.mapper.map(input: data.items.first)))

                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func write(settings: ContributionSettings) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(()))
                return
            }

            self.storage.fetch(predicate: nil,
                               CDContributionSettings.self) { result in
                switch result {
                case .success(let data):
                    do {
                        _ = try self.dtoMapper
                            .map(input: (settings,
                                         data.items.first,
                                         data.context))
                            .get()

                        try data.context.save()
                        promise(.success(()))
                    } catch let error {
                        promise(.failure(error))
                    }

                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
