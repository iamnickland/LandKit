//
//  Int+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import Foundation

public extension Int {
  
    /// 这是一个内置函数
    /// - Parameters:
    ///   - lower: 内置为 0，可根据自己要获取的随机数进行修改。
    ///   - upper: 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
    /// - Returns: [lower,upper) 之间的半开半闭区间的数。
    static func randomIntNumber(lower: Int = 0, upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }

    /// 生成某个区间的随机数
    /// - Parameter range: 区间值
    /// - Returns: 随机数
    static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}
