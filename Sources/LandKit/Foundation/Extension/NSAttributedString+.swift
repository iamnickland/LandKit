//
//  NSAttributedString+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation
import UIKit

public extension NSAttributedString {
    /// 计算高度
    func height(of width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        label.numberOfLines = 0
        label.attributedText = self
        
        label.sizeToFit()
        return label.frame.height
    }
}

/// 构建
public extension NSAttributedString {
    
    /// 通过字符串构建富文本
    /// - Parameters:
    ///   - string: 字符串
    ///   - font: 字体
    ///   - foregroundColor: 字体颜色
    ///   - style: 样式
    /// - Returns: 富文本
    class func create(_ string: String, font: UIFont, foregroundColor: UIColor, backgroundColr: UIColor? = nil, style: NSParagraphStyle? = nil) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: foregroundColor]
        if let backgroundColr = backgroundColr {
            attributes[.backgroundColor] = backgroundColr
        }
        if let paragraphStyle = style {
            attributes[.paragraphStyle] = style
        }
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    /// 通过图标构建富文本
    /// - Parameters:
    ///   - image: 图标
    ///   - bounds: 图片坐标和大小
    /// - Returns: 富文本
    class func create(_ image: UIImage, bounds: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = bounds
        let attributedString = NSAttributedString(attachment: attachment)
        return attributedString
    }
}
