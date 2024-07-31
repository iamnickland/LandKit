//
//  Optional+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import Foundation

public extension Optional {
    func `let`<T>(_ transform: (Wrapped) -> T?) -> T? {
        if case let .some(value) = self {
            return transform(value)
        }
        return nil
    }
  
    /// 是否为nil
    var isNil: Bool {
        return self == nil
    }
 
    /// 是否是可选值
    var isSome: Bool {
        return self != nil
    }
  
    /// 可选值取值
    /// - Parameters:
    ///   - defaultValue: 默认值
    ///   - calc: 如果可选值有值，calc也返回了对应的值，就取calc返回的值，否则去可选值解析后的值
    /// - Returns: 结果
    func or(_ defaultValue: @autoclosure () -> Wrapped, _ calc: ((Wrapped) -> Wrapped)? = nil) -> Wrapped {
        switch self {
        case let .some(value):
            if let calc = calc {
                return calc(value)
            } else {
                return value
            }
        case .none:
            return defaultValue()
        }
    }
 
    /// 可选值不为空且可选值满足 `predicate` 条件才返回，否则返回 `nil`
    /// - Parameter predicate: 条件，返回true和false
    /// - Returns: 结果
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let unwrapped = self,
              predicate(unwrapped) else { return nil }
        return unwrapped
    }
 
    /// 当可选值不为空时，执行 `some` 闭包
    /// - Parameter some: some description
    func onSome(_ some: (Wrapped) -> Void) {
        guard let unwrapped = self else { return }
        some(unwrapped)
    }
 
    /// 当可选值为空时，执行 `none` 闭包
    /// - Parameter none: none description
    func onNone(_ none: () -> Void) {
        guard self == nil else { return }
        none()
    }
}
