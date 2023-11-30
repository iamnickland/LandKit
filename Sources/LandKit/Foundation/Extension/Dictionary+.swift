//
//  Dictionary+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation

public extension Dictionary {
    /// 数组合并
    /// - Parameter dict: 待合并的字典
    mutating func merge(_ dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
