//
//  IndexPath+.swift
//
//
//  Created by Anakin on 2024/7/31.
//

import Foundation

public extension IndexPath {
    // MARK: 1.1、 {section, row}

    /// {section, row}
    var string: String {
        return String(format: "{%d, %d}", section, row)
    }
    
    // MARK: 1.2、当前 NSIndexPath 的前一个 NSIndexPath

    /// 当前 NSIndexPath 的前一个 NSIndexPath
    var previousRow: IndexPath {
        if row == 0 {
            return self
        }
        return IndexPath(row: row - 1, section: section)
    }
    
    // MARK: 1.3、当前 NSIndexPath 的后一个 NSIndexPath

    /// 当前 NSIndexPath 的后一个 NSIndexPath
    var nextRow: IndexPath {
        return IndexPath(row: row + 1, section: section)
    }
}
