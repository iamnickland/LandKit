//
//  Bool+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/31.
//

import Foundation
import UIKit

// MARK: - Bool + LKPOPCompatible

extension Bool: LKPOPCompatible {}

// MARK: - 一、基本的扩展

public extension LKPOP where Base == Bool {
    // MARK: 1.1、Bool 值转 Int

    /// Bool 值转 Int
    var boolToInt: Int { return base ? 1 : 0 }
}
