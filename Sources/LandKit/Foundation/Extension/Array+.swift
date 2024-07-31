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
    /// - Returns: 去重后的数组
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
    
    /// 字典转换为JSONString
    func toJSONString() -> String? {
        let array = self
        guard JSONSerialization.isValidJSONObject(array) else { return nil }
        let data: NSData = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        return JSONString as? String
    }
    
    /// 分隔数组
    /// - Parameter condition: condition description
    /// - Returns: description
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }
}

// MARK: - 数组 有关索引 的扩展方法

public extension Array where Element: Equatable {
    /// 获取数组中的指定元素的索引值
    /// - Parameter item: 元素
    /// - Returns: 索引值数组
    func indexes(_ item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0 ..< count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }
 
    /// 获取元素首次出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func firstIndex(_ item: Element) -> Int? {
        for (index, value) in enumerated() where value == item {
            return index
        }
        return nil
    }
 
    /// 获取元素最后出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func lastIndex(_ item: Element) -> Int? {
        let indexs = indexes(item)
        return indexs.last
    }
 
    /// 获取两个元素的相同元素
    /// - Parameter array: 数组元素
    /// - Returns: 返回相同的元素
    func sameElement(array: [Element]) -> [Element] {
        var dict1: [String: Int] = [:]
        for item in self {
            dict1["\(item)"] = 1
        }
        var sameElements: [Element] = []
        for item in array {
            if dict1["\(item)"] == 1 {
                // 此处便可取到相同元素
                debugPrint("相同的元素：\(item)")
                sameElements.append(item)
            }
        }
        return sameElements
    }
}

// MARK: - 遵守 Equatable 协议的数组 (增删改查) 扩展

public extension Array where Element: Equatable {
    // MARK: 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)

    /// 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    /// - Parameters:
    ///   - element: 要删除的元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func remove(_ element: Element, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        
        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        // 倒序删除
        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }
    
    // MARK: 从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素

    /// 从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
    /// - Parameters:
    ///   - elements: 被删除的数组元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        for element in elements {
            if contains(element) {
                remove(element, isRepeat: isRepeat)
            }
        }
        return self
    }
}

// MARK: - 遵守 NSObjectProtocol 协议对应数组的扩展方法

public extension Array where Element: NSObjectProtocol {
    // MARK: 删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素

    /// 删除数组中遵守NSObjectProtocol协议的元素
    /// - Parameters:
    ///   - object: 元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        for i in 0 ..< count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat {
                    break
                }
            }
        }
        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }
    
    // MARK: 删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除

    /// 删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除
    /// - Parameters:
    ///   - objects: 遵守NSObjectProtocol的数组
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func removeArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        for object in objects {
            if contains(where: { $0.isEqual(object) }) {
                remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}
