//
//  File.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation
import UIKit

// MARK: - ButtonImagePosition

/// 按钮 图片位置
public enum ButtonImagePosition: Int {
    case imageTop = 0
    case imageLeft
    case imageBottom
    case imageRight
}

public extension UIButton {
    /// 设置图片类型和位置
    /// - Parameters:
    ///   - type: 图片位置类型
    ///   - space: 图片和文字的距离
    func setImagePosition(type: ButtonImagePosition, Space space: CGFloat = 0) {
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

// MARK: - quick 快速构建

public extension UIButton {
    convenience init(text: String?, titleColor: UIColor?, fontSize: CGFloat, _ state: UIControl.State = []) {
        self.init(frame: CGRect.zero)
        setBackgroundColor(.lightGray, for: .disabled)
        setTitle(text, for: state)
        setTitleColor(titleColor, for: state)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State = .normal) {
        setBackgroundImage(color.toImage(size: CGSize(width: 1.0, height: 1.0)), for: state)
    }

    func setTitle(_ title: String, titleColor: UIColor? = nil, font: UIFont? = nil, for state: UIControl.State = .normal) {
        let attributeString = NSMutableAttributedString(string: title)

        if let font = font {
            attributeString.addAttribute(.font, value: font, range: .init(location: 0, length: attributeString.length))
        }

        if let titleColor = titleColor {
            attributeString.addAttribute(.foregroundColor,
                                         value: titleColor,
                                         range: .init(location: 0, length: attributeString.length))
        }
   
        setAttributedTitle(attributeString,
                           for: state)
    }
}
 
