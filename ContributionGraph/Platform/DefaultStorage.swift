//
//  DefaultStorage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Foundation
import CoreData
import Combine

final class DefaultStorageContext: StorageContext {
    let objectContext: NSManagedObjectContext

    init(_ context: NSManagedObjectContext) {
        self.objectContext = context
    }

    func callAsFunction() -> NSManagedObjectContext {
        objectContext
    }

    func newData<T: NSManagedObject>(_ type: T.Type) throws -> T {
        T(context: objectContext)
    }

    func save() throws {
        guard objectContext.hasChanges else { return }

        try objectContext.save()
    }

    func delete<T: NSManagedObject>(object: T) throws {
        objectContext.delete(object)

        try objectContext.save()
    }
}

final class DefaultStorage: Storage {
    enum StorageError: Error {
        case noContext
        case wrongObjectType
    }

    private let name: String

    // TODO: NSPersistentCloudKitContaner
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    lazy var context: DefaultStorageContext = {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return DefaultStorageContext(context)
    }()

    init(name: String) {
        self.name = name
    }

    func fetch<T: NSManagedObject>(predicate: NSPredicate?,
                                   _ type: T.Type,
                                   onCompletion: @escaping OnFetchCompletion<T>) {
        context().perform { [weak self] in
            guard let self else {
                onCompletion(.failure(StorageError.noContext))
                return
            }

            guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
                onCompletion(.failure(StorageError.wrongObjectType))
                return
            }

            request.predicate = predicate

            do {
                let data = try request.execute()
                onCompletion(.success((self.context, data)))
            } catch let error {
                onCompletion(.failure(error))
            }
        }
    }

    func count<T: NSManagedObject>(predicate: NSPredicate?,
                                   _ type: T.Type,
                                   onCompletion: @escaping OnCountCompletion) {
        context().perform { [weak self] in
            guard let self else {
                onCompletion(.failure(StorageError.noContext))
                return
            }

            guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
                onCompletion(.failure(StorageError.wrongObjectType))
                return
            }

            request.predicate = predicate

            do {
                let count = try self.context().count(for: request)
                onCompletion(.success(count))
            } catch let error {
                onCompletion(.failure(error))
            }
        }
    }
}
