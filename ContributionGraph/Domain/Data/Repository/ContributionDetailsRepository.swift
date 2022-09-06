//
//  ContributionDetailsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation
import Combine

/// @mockable
protocol ContributionDetailsRepository {
    func read(date: Date) -> AnyPublisher<ContributionDetails?, Error>
    func write(_ note: ContributionNote, at date: Date) -> AnyPublisher<Void, Error>
}
