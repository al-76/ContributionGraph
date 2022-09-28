//
//  ContributionSettingsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.09.2022.
//

import Combine

/// @mockable
protocol ContributionSettingsRepository {
    func read() -> AnyPublisher<ContributionSettings, Error>
    func write(settings: ContributionSettings) -> AnyPublisher<Void, Error>
}
