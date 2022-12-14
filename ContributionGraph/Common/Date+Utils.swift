//
//  Date+Utils.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation

extension Date {
    func days(to date: Date) -> Int {
        abs(Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0)
    }
}

extension Date {
    func weekday() -> Int {
        (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1)
    }

    func weekOfMonth() -> Int {
        (Calendar.current.dateComponents([.weekOfMonth], from: self).weekOfMonth ?? 1)
    }

    func weeks(to date: Date) -> Int {
        let days = days(to: date)
        return (days / 7) + (days % 7 == 0 ? 0 : 1)
    }
}

extension Date {
    func yesterday() -> Date {
        days(ago: 1)
    }
}

extension Date {
    func days(ago offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -offset, to: self) ?? self
    }
}

extension Date {
    func month() -> Int {
        (Calendar.current.dateComponents([.month], from: self).month ?? 1) - 1
    }
}

extension Date {
    static var neutral: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date.now) ?? Date.now
    }
}

extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
