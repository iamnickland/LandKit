//
//  UIButton+.swift
//  LandKit
//
//  Created by LandKit on 2024/1/7.
//

import UIKit

/// 按钮 图片位置
public enum ButtonImagePosition: Int {
    case imageTop = 0
    case imageLeft
    case imageBottom
    case imageRight
}

extension UIButton {
    /// 设置图片类型和位置
    /// - Parameters:
    ///   - type: 图片位置类型
    ///   - space: 图片和文字的距离
    public func setImagePosition(type: ButtonImagePosition, Space space: CGFloat = 0) {
        let imageWith: CGFloat = (imageView?.frame.size.width)!
        let imageHeight: CGFloat = (imageView?.frame.size.height)!
      
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0

        labelWidth = CGFloat(titleLabel!.intrinsicContentSize.width)
        labelHeight = CGFloat(titleLabel!.intrinsicContentSize.height)

        var imageEdgeInsets = UIEdgeInsets()
        var labelEdgeInsets = UIEdgeInsets()
       
        switch type {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight - space / 2.0, right: 0)
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: -imageWith, bottom: 0, right: 0)
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith - space / 2.0, bottom: 0, right: imageWith + space / 2.0)
        }
        titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
