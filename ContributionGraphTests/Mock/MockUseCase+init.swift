//
//  MockUseCase+init.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 24.08.2022.
//

import Combine
import Cuckoo

extension MockUseCase {
    convenience init(_ publisher: AnyPublisher<Output, Error>) {
        self.init()

        stub(self) { stub in
            stub.callAsFunction(any()).thenReturn(publisher)
        }
    }
}
