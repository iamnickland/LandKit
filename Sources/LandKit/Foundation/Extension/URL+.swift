//
//  URL+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation
import UIKit

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
    
    /// 提取链接中的参数以字典形式显示
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
    
    /// 检测应用是否能打开这个URL实例
    /// - Returns: 结果
    func verifyURL() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}
