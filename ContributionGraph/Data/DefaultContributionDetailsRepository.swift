//
//  DefaultContributionDetailsRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation
import Combine

final class DefaultContributionDetailsRepository: ContributionDetailsRepository {
    typealias Mapper = AnyMapper<CDContribution, ContributionDetails?>
    typealias DtoMapper =
    AnyMapper<(Date, ContributionNote, CDContribution?, StorageContext),
              Result<CDContributionNote, Error>>
    
    private let storage: Storage
    private let mapper: Mapper
    private let dtoMapper: DtoMapper

    init(storage: Storage,
         mapper: Mapper,
         dtoMapper: DtoMapper) {
        self.storage = storage
        self.mapper = mapper
        self.dtoMapper = dtoMapper
    }
    
    func read(date: Date) -> AnyPublisher<ContributionDetails?, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(nil))
                return
            }
            
            self.storage
                .fetch(predicate: self.predicateContribution(at: date), CDContribution.self) { result in
                    switch result {
                    case .success(let data):
                        guard let dtoContribution = data.items.first else {
                            promise(.success(nil))
                            break
                        }          
                        promise(.success(self.mapper
                            .map(input: dtoContribution)))
                        
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func write(_ note: ContributionNote, at date: Date) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(()))
                return
            }
            
            self.storage
                .fetch(predicate: self.predicateContribution(at: date), CDContribution.self) { result in
                    switch result {
                    case .success(let data):
                        do {
                            try self.handleWriteResult(at: date,
                                                       for: note,
                                                       data.context,
                                                       data.items)
                            
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
    
    private func handleWriteResult(at date: Date,
                                   for note: ContributionNote,
                                   _ context: StorageContext,
                                   _ items: [CDContribution]) throws {
        let result = dtoMapper
            .map(input: (date, note, items.first, context))
        switch result {
        case .success:
            break // nothing to do because it's binded to context
            
        case .failure(let error):
            throw error
        }
        
        try context.save()
    }
        
        
    private func predicateContribution(at date: Date) -> NSPredicate {
        NSPredicate(format: "date=%@", date as NSDate)
    }
}
