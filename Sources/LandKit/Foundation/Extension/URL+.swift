//
//  URL+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation

public extension URL {
    /// 对URL进行拼接query
    /// - Parameter items: 带拼接的query items
    /// - Returns: 拼接后的完整的URL
    func appendQuery(items items: [URLQueryItem]) -> URL {
        // 创建URLComponents实例，可能会返回nil因此使用guard进行可选绑定
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false), !items.isEmpty else {
            // Failed to create URL components from original URL
            return self
        }
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = []
        }
        // 将新的查询项添加到现有查询项（如果有）
        urlComponents.queryItems?.append(contentsOf: items)
        // 构建新的带参数的URL
        guard let updatedURL = urlComponents.url else {
            // Failed to create updated URL from components
            return self
        }

        return updatedURL
    }
}
