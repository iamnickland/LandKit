//
//  CALayer+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation
import UIKit

public extension CALayer {
    /// 为layer添加渐变色背景 和边线
    ///
    /// - Parameters:
    ///   - colors: 渐变色
    ///   - cornerRadius: 圆角
    ///   - borderWidth: 边线宽度
    ///   - borderColor: 边线颜色
    func lkAddGradientLayer(colors: [UIColor], cornerRadius: CGFloat, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        guard bounds != .zero, sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer == nil else {
            // 必须先更新frame，并且未添加过，才添加
            return
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.masksToBounds = true
        insertSublayer(gradientLayer, at: 0)

        if let borderColor, let borderWidth {
            let borderLayer = CALayer()
            borderLayer.frame = bounds
            borderLayer.cornerRadius = cornerRadius
            borderLayer.borderWidth = borderWidth
            borderLayer.borderColor = borderColor.cgColor
            insertSublayer(borderLayer, above: gradientLayer)
        }
    }
}
