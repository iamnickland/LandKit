//
//  LKJSON.swift
//  LandKit
//
//  Created by Anakin on 2024/7/31.
//

import Foundation

// MARK: - LKJSON

public protocol LKJSON: Codable {
    func toJSONString() -> String?
}
 
// MARK: - 扩展协议方法

public extension LKJSON {
    // MARK: 将数据转成可用的JSON模型

    func toJSONString() -> String? {
        if let encodedData = try? JSONEncoder().encode(self) {
            // 从encoded对象获取String
            return String(data: encodedData, encoding: .utf8)
        }
        return nil
    }
}

public extension Encodable {
    /// 编码
    var encoded: Data? {
        try? JSONEncoder().encode(self)
    }
}
