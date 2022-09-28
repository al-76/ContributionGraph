//
//  ContributionSettingsMapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.09.2022.
//

import Foundation

struct ContributionSettingsMapper: Mapper {
    func map(input: CDContributionSettings?) -> ContributionSettings {
        ContributionSettings(weekCount: Int(input?.weekCount ?? 15))
    }
}

struct DtoContributionSettingsMapper: Mapper {
    typealias Input = (ContributionSettings,
                       CDContributionSettings?,
                       StorageContext)

    func map(input: Input) -> Result<CDContributionSettings, Error> {
        let settings = input.0
        let context = input.2
        do {
            if let dtoSettings = input.1 {
                // Change settings
                dtoSettings.weekCount = Int32(settings.weekCount)
                return .success(dtoSettings)
            } else {
                // New settings
                let dtoSettings = try context.newData(CDContributionSettings.self)
                dtoSettings.weekCount = Int32(settings.weekCount)
                return .success(dtoSettings)
            }
        } catch let error {
            return .failure(error)
        }
    }
}
