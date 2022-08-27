//
//  DefaultContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Combine
import Foundation

final class DefaultContributionRepository: ContributionRepository {
    typealias ContributionMapper = AnyMapper<CDContribution, Contribution>
    typealias DtoContributionMapper = AnyMapper<(StorageContext, Contribution), Result<CDContribution, Error>>
    typealias DtoContributionUpdateMapper = AnyMapper<(CDContribution, CDContributionNote), CDContribution>
    typealias ContributionNoteMapper = AnyMapper<(StorageContext, NewContributionNote), Result<CDContributionNote, Error>>

    
    private let storage: Storage
    private let contributionMapper: ContributionMapper
    private let dtoContributionMapper: DtoContributionMapper
    private let dtoContributionUpdateMapper: DtoContributionUpdateMapper
    private let contributionNoteMapper: ContributionNoteMapper
    
    init(storage: Storage,
         contributionMapper: ContributionMapper,
         dtoContributionMapper: DtoContributionMapper,
         dtoContributionUpdateMapper: DtoContributionUpdateMapper,
         contributionNoteMapper: ContributionNoteMapper) {
        self.storage = storage
        self.contributionMapper = contributionMapper
        self.dtoContributionMapper = dtoContributionMapper
        self.dtoContributionUpdateMapper = dtoContributionUpdateMapper
        self.contributionNoteMapper = contributionNoteMapper
    }
    
    func read() -> AnyPublisher<[Contribution], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success([]))
                return
            }
            
            self.storage
                .fetch(predicate: nil, CDContribution.self) { result in
                    switch result {
                    case let .success(data):
                        promise(.success(data.items
                            .map {
                                self.contributionMapper.map(input: $0)
                            }))
                        
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func write(note: NewContributionNote) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(()))
                return
            }
            
            self.storage
                .fetch(predicate: NSPredicate(format: "date=%@", Date.neutral.days(ago: note.day) as NSDate), CDContribution.self) { result in
                    switch result {
                    case let .success(data):
                        do {
                            try self.handleWriteResult(for: note,
                                                  data.context,
                                                  data.items)
                            
                            promise(.success(()))
                        } catch let error {
                            promise(.failure(error))
                        }
                        
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleWriteResult(for note: NewContributionNote, _ context: StorageContext, _ items: [CDContribution]) throws {
        if let contribution = items.first {
            // add a note to exist contribution
            let newNote = contributionNoteMapper
                .map(input: (context, note))
            switch newNote {
            case let .success(data):
                _ = dtoContributionUpdateMapper
                    .map(input: (contribution, data))

            case let .failure(error):
                throw error
            }
        } else {
            // create new contribution
            let contribution = Contribution(date: Date.neutral.days(ago: note.day),
                                                notes: [note.note])
            let newContribution = dtoContributionMapper
                .map(input: (context, contribution))
            switch newContribution {
            case .success:
                break // nothing to do because it's binded to context
                
            case let .failure(error):
                throw error
            }
        }
        
        try context.save()
    }
}
