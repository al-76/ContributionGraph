//
//  Mapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 25.09.2022.
//

protocol Mapper<Input, Output> {
    associatedtype Input
    associatedtype Output

    func map(input: Input) -> Output
}
