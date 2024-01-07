//
//  DateFormatter+.swift
//  LandKit
//
//  Created by LandKit on 2023/12/24.
//

import Foundation

public extension DateFormatter {
    /// 格式类型
    enum FormatType: String {
        case yearMonthDay = "yyyy-MM-dd"
        case yearMonthDayHourMinute = "yyyy-MM-dd HH:mm"
        case hourMinute = "HH:mm"
    }
    
    static func formatDate(date: Date, format: FormatType) -> String {
        let threadLocalKey = "LandKit.dateFormatter" // 定义线程局部存储的键
        // 检查线程局部存储中是否已经存在DateFormatter实例, 如果线程局部存储中不存在DateFormatter实例，则创建并存储一个新的实例
        if let formatter = Thread.current.threadDictionary[threadLocalKey] as? DateFormatter {
            formatter.dateFormat = format.rawValue
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            formatter.locale = Locale(identifier: "en_US_POSIX")
            Thread.current.threadDictionary[threadLocalKey] = formatter
            return formatter.string(from: date)
        }
    }
}
