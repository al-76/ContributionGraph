//
//  DefaultStorage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Foundation
import CoreData

final class DefaultStorage: Storage {
    private let name: String
    
    // TODO: NSPersistentCloudKitContaner
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    init(name: String) {
        self.name = name
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
        let context = persistentContainer.viewContext
        
        return try context.fetch(request)
    }
    
    func save() throws -> Bool  {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return false }
        
        try context.save()
        
        return true
    }
    
    func delete<T: NSManagedObject>(object: T) throws {
        let context = persistentContainer.viewContext
        
        context.delete(object)
        try context.save()
    }
}
