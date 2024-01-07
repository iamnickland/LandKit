//
//  Array+.swift
//  LandKit
//
//  Created by LandKit on 2023/12/23.
//

/*
 // 基础类型去重
 let arrays = ["1", "2", "2", "3", "4", "4"]
 let filterArrays = arrays.filterDuplicates({$0})
 print(filterArrays)

 // model类的去重
 let modelArrays = [Model("1"), Model("1"), Model("2"), Model("3")]
 let filterModels = modelArrays.filterDuplicates({$0.name})
 print(filterModels)

 */

import Foundation
import UIKit

public extension Collection {
    /// 防止溢出
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}

public extension Array {
    /// 安全插入值
    /// - Parameters:
    ///   - newElement: 新的元素
    ///   - index: 索引
    mutating func insert(safe newElement: Element, at index: Int) {
        guard index >= 0, index <= count else {
            return
        }
        insert(newElement, at: index)
    }

    @discardableResult
    mutating func remove(safeAt index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return remove(at: index)
    }
    
    /// 过滤去重
    /// - Parameter filter: 条件
    /// - Returns: 去重构的数组
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({ filter($0) }).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
