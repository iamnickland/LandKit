//
//  File.swift
//
//
//  Created by Anakin on 2024/7/31.
//

import Foundation
import UIKit

// MARK: - LKPOP

public struct LKPOP<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - LKPOPCompatible

public protocol LKPOPCompatible {}

public extension LKPOPCompatible {
    static var lk: LKPOP<Self>.Type {
        get { LKPOP<Self>.self }
        set {}
    }
    
    var lk: LKPOP<Self> {
        get { LKPOP(self) }
        set {}
    }
}

// MARK: - LKSwiftPropertyCompatible

/// Define Property protocol
protocol LKSwiftPropertyCompatible {
    /// Extended type
    associatedtype T
    
    /// Alias for callback function
    typealias SwiftCallBack = (T?) -> Void
    
    /// Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack? { get set }
}
