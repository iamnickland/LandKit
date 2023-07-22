//
//  DispatchQueue+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation

public extension DispatchQueue {
    /// - Parameter closure: Closure to execute.
    func mainIfNeeded(_ closure: @escaping (() -> Void)) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }
        closure()
    }
}
