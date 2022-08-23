//
//  Storage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Foundation
import CoreData

protocol Storage {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]
    func save() throws -> Bool
    func delete<T: NSManagedObject>(object: T) throws
}
