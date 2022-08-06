//
//  Date+Utils.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import Foundation

extension Date {
    func days(to date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}

extension Date {
    func weekday() -> Int {
        (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1)
    }
    
    func weekOfMonth() -> Int {
        (Calendar.current.dateComponents([.weekOfMonth], from: self).weekOfMonth ?? 1)
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
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
