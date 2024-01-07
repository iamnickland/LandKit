//
//  Date+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import Foundation

public extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    init(seconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    var millisecondsSince1970: TimeInterval {
        (timeIntervalSince1970 * 1000.0).rounded()
    }

    var milliSecondsSince1970: Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    var secondsSince1970: TimeInterval {
        timeIntervalSince1970.rounded()
    }
}

public extension Date {
    func getString(format: String = "yyyy-MM-dd") -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        dayTimePeriodFormatter.locale = .current
//        dayTimePeriodFormatter.timeZone = NSTimeZone(name: timezone) as TimeZone!
        let dateString = dayTimePeriodFormatter.string(from: self)
        return dateString
    }
    
    func reduceToHHMM() -> Date {
        let calendar = Calendar.current
        _ = calendar.component(.month, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = Locale(identifier: "zh")
        return dateFormatter.date(from: "\(hour)/\(minute)/") ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
//        dateFormatter.locale = Locale(identifier: "zh")
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    func reduceToMonthDay() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
//        dateFormatter.locale = Locale(identifier: "zh")
        return dateFormatter.date(from: "\(month)/\(day)/") ?? Date()
    }
    
    func reduceToMonth() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: "\(year)-\(month)-19T17:10:08+0000")
        return date ?? Date()
    }
}

public extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 { return "\(years(from: date))y" }
        if months(from: date) > 0 { return "\(months(from: date))M" }
        if weeks(from: date) > 0 { return "\(weeks(from: date))w" }
        if days(from: date) > 0 { return "\(days(from: date))d" }
        if hours(from: date) > 0 { return "\(hours(from: date))h" }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
