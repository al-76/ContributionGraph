//
//  UseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 24.09.2022.
//

import Foundation
import Combine

protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error>
}
