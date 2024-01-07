//
//  Optional+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import Foundation

extension Optional {
    func `let`<T>(_ transform: (Wrapped) -> T?) -> T? {
        if case let .some(value) = self {
            return transform(value)
        }
        return nil
    }
}
