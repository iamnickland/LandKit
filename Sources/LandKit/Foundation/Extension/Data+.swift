//
//  Data+.swift
//  LandKit
//
//  Created by Anakin on 2024/8/1.
//

import Foundation

public extension Data {
    /// 解码
    func decoded<T: Decodable>() -> T? {
        try? JSONDecoder().decode(T.self, from: self)
    }
}
