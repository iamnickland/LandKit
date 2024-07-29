//
//  BaseProtocol.swift
//  LandKit
//
//  Created by LandKit on 2023/9/9.
//

import Foundation

// MARK: - LKBaseViewModel

/// 基本视图模型
@objc public protocol LKBaseViewModel {}

// MARK: - LKBaseCellViewModel

/// 基本cell视图模型
public protocol LKBaseCellViewModel {
    /// 行高
    var rowHeight: CGFloat { get }
}

// MARK: - LKListDataSource

/// 列表数据源协议
@MainActor public protocol LKListDataSource {
    func numberOfSections() -> Int
    
    func numberOfRowsIn(_ section: Int) -> Int
    
    func itemForRowAt<T: LKBaseCellViewModel>(_ indexPath: IndexPath) -> T?
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
    
    func onDidSelectRowAt(_ indexPath: IndexPath)
}

// MARK: - UIComponentsProtocol

/// UI组件协议
protocol UIComponentsProtocol {
    /// 添加
    func addUIComponents()
    /// 布局
    func layoutUIComponents()
    /// 更新
    func updateUIComponents()
}
