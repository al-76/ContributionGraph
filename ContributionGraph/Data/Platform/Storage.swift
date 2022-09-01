//
//  Storage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Foundation
import CoreData
import Combine

protocol StorageContext {
    func newData<T: NSManagedObject>(_ type: T.Type) throws -> T
    func save() throws
    func delete<T: NSManagedObject>(object: T) throws
}

protocol Storage {
    typealias OnCompletion<T> = (Result<(context: StorageContext, items: [T]), Error>) -> Void

    func fetch<T: NSManagedObject>(predicate: NSPredicate?,
                                   _ type: T.Type,
                                   onCompletion: @escaping OnCompletion<T>)
}
