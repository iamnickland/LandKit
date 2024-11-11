//
//  DecodeIfPresentEnableInteger.swift
//  HPBaseCommon
//
//  Created by Darwin on 2023/11/28.
//

import Foundation

/// 在解析Bool类型时，允许把Number类型的值转换为Bool
@propertyWrapper public struct DecodeIfPresentEnableInteger: CodableContainer {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: DecodeIfPresentEnableInteger.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentEnableInteger {
        if let valueFromInt = try? decodeFromStringIfPresent(Int.self, forKey: key) {
            return .init(wrappedValue: Bool.init(truncating: NSNumber(value: valueFromInt)))
        } else {
            return .init(wrappedValue: try decodeFromStringIfPresent(Bool.self, forKey: key) ?? true)
        }
    }
}
