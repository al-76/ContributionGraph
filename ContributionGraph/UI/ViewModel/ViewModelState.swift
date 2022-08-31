//
//  ViewModelState.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 29.08.2022.
//

import Foundation

enum ViewModelState<T> {
    case loading
    case success(T)
    case failure(Error)
}
