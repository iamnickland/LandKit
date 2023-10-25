//
//  BaseProtocol.swift
//  LandKit
//
//  Created by Nick Land on 2023/9/9.
//

import Foundation

/// 基本视图模型
@objc public protocol LKBaseViewModel {}

/// 基本cell视图模型
public protocol LKBaseCellViewModel {
    /// 行高
    var rowHeight: CGFloat { get }
}

/// 列表数据源协议
@MainActor public protocol LKListDataSource {
    
    func numberOfSections() -> Int
    
    func numberOfRowsIn(_ section: Int) -> Int
    
    func itemForRowAt<T: LKBaseCellViewModel>(_ indexPath: IndexPath) -> T?
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
    
    func onDidSelectRowAt(_ indexPath: IndexPath)
}
