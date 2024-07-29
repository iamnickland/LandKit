//
//  DateFormatter+.swift
//  LandKit
//
//  Created by LandKit on 2023/12/24.
//

import Foundation

public typealias LKDateFormatter = DateFormatter

public extension LKDateFormatter {
    /// 项目用到的所有时间格式，没有的话在这里自行扩展
    enum FormatType: String {
        /// "MM/dd HH:mm"
        case monthDayHourMinute = "MM/dd HH:mm"
        /// "MM-dd HH:MM"
        case monthDayHourMinuteStyle2 = "MM-dd HH:mm"
        /// "MM-dd HH:MM"
        case monthDay = "MM-dd"
        case dayMonth = "dd/MM"
        /// "yyyy-MM-dd"
        case yearMonthDay = "yyyy-MM-dd"
        case dayMonthYear = "dd/MM/yyyy"
        /// "yyyy-MM-dd HH:mm"
        case yearMonthDayHourMinute = "yyyy-MM-dd HH:mm"
        /// "yyyy-MM-dd HH:mm:ss"
        case yearMonthDayHourMinuteSecond = "yyyy-MM-dd HH:mm:ss"
        /// "HH:mm"
        case hourMinute = "HH:mm"
        /// "HH:mm:ss.SSS"
        case debugLog = "HH:mm:ss.SSS"
        /// "yyyy-MM-dd HH:mm:ss ZZZZ eg: 2012-12-31 13:29:59 +0000"
        case fullWithZone = "yyyy-MM-dd HH:mm:ss.SSS ZZZZ"
        /// "HH:mm:ss - d.M.yy"
        case hourMinuteSecondDMYY = "HH:mm:ss - d.M.yy"
        /// "yyyy.MM.dd, h:mm a"
        case maintain = "yyyy.MM.dd, HH:mm a"
        /// "dd-MM-yyyy"
        case dayMonthYearStyle2 = "dd-MM-yyyy"
    }
    
    static var currentDateFormatter: LKDateFormatter {
        // 定义线程局部存储的键
        let threadLocalKey = "LandKit.dateFormatter"
        
        // 检查线程局部存储中是否已经存在DateFormatter实例
        if let formatter = Thread.current.threadDictionary[threadLocalKey] as? LKDateFormatter {
            return formatter
        } else {
            // 如果线程局部存储中不存在DateFormatter实例，则创建并存储一个新的实例
            let formatter = LKDateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            Thread.current.threadDictionary[threadLocalKey] = formatter
            return formatter
        }
    }
    
    static func formatDate(date: Date, format: FormatType) -> String {
        currentDateFormatter.dateFormat = format.rawValue
        return currentDateFormatter.string(from: date)
    }

    static func date(from dateString: String, format: FormatType) -> Date? {
        currentDateFormatter.dateFormat = format.rawValue
        return currentDateFormatter.date(from: dateString)
    }
    
    static func formatDate(date: Date, formatString: String) -> String {
        currentDateFormatter.dateFormat = formatString
        return currentDateFormatter.string(from: date)
    }
}
