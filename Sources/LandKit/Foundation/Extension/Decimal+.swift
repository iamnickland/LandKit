//
//  Decimal+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation

// MARK: - LKDecimalStyle

/// 项目用到的所有金额格式，没有的话在这里自行扩展
public enum LKDecimalStyle: String {
    /// 千分位金额
    case thousandthPlaceStyle
    
    /// 赔率，两位小数 不四舍五入
    case odds
    
    /// 样式
    var positiveFormat: String {
        switch self {
        case .thousandthPlaceStyle:
            return "###,###"
        case .odds:
            return "0.##"
        }
    }
    
    var locale: Locale {
        switch self {
        case .thousandthPlaceStyle,
             .odds:
            return Locale.current
        }
    }
}

public extension Decimal {
    /// style: 样式   roundingMode: 四舍五入模式
    func format(_ style: LKDecimalStyle, _ roundingMode: NumberFormatter.RoundingMode = .down) -> String {
        let formatter = checkNumberFormatter()
        formatter.locale = style.locale
        formatter.positiveFormat = style.positiveFormat
        formatter.roundingMode = roundingMode
        let original = NSDecimalNumber(decimal: self)
        return formatter.string(for: original) ?? ""
    }
    
    /// 防止重复初始化NumberFormatter，性能优化
    fileprivate func checkNumberFormatter() -> NumberFormatter {
        // 定义线程局部存储的键
        let threadLocalKey = "LandKit.DecimalFormatter"
        
        // 检查线程局部存储中是否已经存在NumberFormatter实例
        if let formatter = Thread.current.threadDictionary[threadLocalKey] as? NumberFormatter {
            return formatter
        } else {
            // 如果线程局部存储中不存在NumberFormatter实例，则创建并存储一个新的实例
            let formatter = NumberFormatter()
            Thread.current.threadDictionary[threadLocalKey] = formatter
            return formatter
        }
    }
}

/// 去掉小数部分
public extension Decimal {
    func roundedDown() -> Decimal {
        var original = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &original, 0, .down)
        return rounded
    }
}
