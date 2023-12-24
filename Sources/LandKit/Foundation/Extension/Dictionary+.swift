//
//  Dictionary+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

/*
 // 数组拆分
 let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 let n = 3
 let result = stride(from: 0, to: arr.count, by: n).map {
     Array(arr[$0..<min($0+n, arr.count)])
 }
 print(result) // 输出 [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]
 
 */

import Foundation

public extension Dictionary {
    /// 合并数据
    /// - Parameter dict: 待合并的字典
    mutating func merge(_ dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    /// 合并数据
    /// - Parameters:
    ///   - other: 另外一组数据
    ///   - replace: 如果key相同是否替换原有数据
    mutating func mergeWith(_ other: [Key: Value], replace: Bool = true) {
        if replace {
            merge(other) { _, another in another }
        } else {
            merge(other) { current, _ in current }
        }
    }
}
