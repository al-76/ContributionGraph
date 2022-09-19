//
//  DefaultContributionDetailsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation
import Combine

final class DefaultContributionDetailsRepository: ContributionDetailsRepository {
    enum RepositoryError: Error {
        case noContribution
    }

    private let storage: Storage
    private let detailsMapper: ContributionDetailsMapper
    private let dtoNoteMapper: DtoContributionNoteMapper
    private let dtoContributionMapper: DtoContributionMapper

    init(storage: Storage,
         detailsMapper: ContributionDetailsMapper,
         dtoNoteMapper: DtoContributionNoteMapper,
         dtoContributionMapper: DtoContributionMapper) {
        self.storage = storage
        self.detailsMapper = detailsMapper
        self.dtoNoteMapper = dtoNoteMapper
        self.dtoContributionMapper = dtoContributionMapper
    }

    func read(date: Date) -> AnyPublisher<ContributionDetails?, Error> {
        fetch(predicate: predicateContribution(at: date),
              defaultValue: nil) { _, data in
            guard let dtoContribution = data.first else {
                return .success(nil)
            }

            return .success(self.detailsMapper
                .map(input: dtoContribution))
        }
    }

    func write(_ note: ContributionNote, at date: Date) -> AnyPublisher<Void, Error> {
        fetch(predicate: predicateContribution(at: date),
              defaultValue: ()) { context, data in
            do {
                try self.handleWriteResult(date, note, context, data)
                return .success(())
            } catch let error {
                return .failure(error)
            }
        }
    }

    func delete(_ note: ContributionNote, to contribution: Contribution) -> AnyPublisher<Void, Error> {
        fetch(predicate: predicateContribution(at: contribution.date),
              defaultValue: ()) { context, data in
            do {
                try self.handleDeleteResult(contribution, note, context, data)
                return .success(())
            } catch let error {
                return .failure(error)
            }
        }
    }

    private typealias FetchOnCompletion<T> = (StorageContext, [CDContribution]) -> Result<T, Error>

    private func fetch<T>(predicate: NSPredicate,
                          defaultValue: T,
                          onCompletion: @escaping FetchOnCompletion<T>) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(defaultValue))
                return
            }

            self.storage
                .fetch(predicate: predicate, CDContribution.self) { result in
                    switch result {
                    case .success(let data):
                        promise(onCompletion(data.context, data.items))

                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    private func handleWriteResult(_ date: Date,
                                   _ note: ContributionNote,
                                   _ context: StorageContext,
                                   _ items: [CDContribution]) throws {
        let result = dtoNoteMapper
            .map(input: (date, note, items.first, context))
        switch result {
        case .success:
            break // nothing to do because it's binded to context

        case .failure(let error):
            throw error
        }

        try context.save()
    }

    private func handleDeleteResult(_ contribution: Contribution,
                                    _ note: ContributionNote,
                                    _ context: StorageContext,
                                    _ items: [CDContribution]) throws {
        guard let dtoContribution = items.first else {
            throw RepositoryError.noContribution
        }

        let contribution = Contribution(date: contribution.date,
                                        count: contribution.count - 1)
        let modDtoContribution = dtoContributionMapper
            .map(input: (dtoContribution, contribution))
        let result = dtoNoteMapper
            .map(input: (contribution.date,
                         note,
                         modDtoContribution,
                         context))
        switch result {
        case .success(let dtoNote):
            try context.delete(object: dtoNote)

        case .failure(let error):
            throw error
        }

        if contribution.count == 0 {
            try context.delete(object: modDtoContribution)
        }

        try context.save()
    }

    private func predicateContribution(at date: Date) -> NSPredicate {
        NSPredicate(format: "date=%@", date as NSDate)
    }
}
