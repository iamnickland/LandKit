//
//  File.swift
//
//
//  Created by Nick Land on 2023/12/24.
//

import UIKit

extension Bundle {
    /// 指定路径获取Bundle, 使用 eg:
    /// ```
    /// private class Example {}
    /// public static let example: Bundle = bundle(for: Example.self, resource: "example")
    ///
    /// ```
    /// - Parameters:
    ///   - aClass: 类
    ///   - resource: 资源包名称
    /// - Returns: Bundle
    public class func bundle(for aClass: AnyClass, resource: String) -> Bundle {
        let bundle = Bundle(for: aClass)
        guard
            let path = bundle.path(forResource: resource, ofType: "bundle"),
            let aBundle = Bundle(path: path)
        else {
            return Bundle(for: aClass)
        }
        return aBundle
    }
}

extension UIImage {
    /// 根据Bundle读取图片资源
    /// - Parameters:
    ///   - named: 图片名称
    ///   - bundle: budle资源包
    /// - Returns: 图片
    public class func image(with named: String, in bundle: Bundle?) -> UIImage? {
        guard !named.isEmpty else { return nil }
        return UIImage(named: named, in: bundle, with: nil)
    }
}
