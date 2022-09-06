//
//  StorageMockHandler.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 05.09.2022.
//

import Foundation

typealias StorageMockResult<T> = Result<(context: StorageContext, items: [T]), Error>

func storageMockHandler<T>(_ completion: Any,
                           _ result: StorageMockResult<T>) {
    storageMockHandler(completion, result, T.self)
}

func storageMockHandler<T>(_ completion: Any,
                           _ result: StorageMockResult<T>,
                           _ type: T.Type) {
    guard let completion = completion as? StorageMock.OnCompletion<T> else {
        return
    }
    completion(result)
}
