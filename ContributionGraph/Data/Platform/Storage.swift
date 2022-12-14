//
//  Storage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Foundation
import CoreData
import Combine

/// @mockable(history: delete = true)
protocol StorageContext {
    func newData<T: NSManagedObject>(_ type: T.Type) throws -> T
    func save() throws
    func delete<T: NSManagedObject>(object: T) throws
}

/// @mockable
protocol Storage {
    typealias OnFetchCompletion<T> = (Result<(context: StorageContext, items: [T]), Error>) -> Void
    typealias OnCountCompletion = (Result<Int, Error>) -> Void

    func fetch<T: NSManagedObject>(predicate: NSPredicate?,
                                   _ type: T.Type,
                                   onCompletion: @escaping OnFetchCompletion<T>)
    func count<T: NSManagedObject>(predicate: NSPredicate?,
                                   _ type: T.Type,
                                   onCompletion: @escaping OnCountCompletion)
}
