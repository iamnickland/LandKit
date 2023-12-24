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

    /// 获取文本高度
    func heightBounding(of width: CGFloat) -> CGFloat {
        let height = boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                  options: [.usesLineFragmentOrigin],
                                  context: nil).size.height
        
        return ceil(height)
    }
    
    /// 获取文本宽度
    func widthBounding(of height: CGFloat) -> CGFloat {
        let width = boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                 options: [.usesLineFragmentOrigin],
                                 context: nil).size.width
        
        return ceil(width)
    }

    func calcHeight(for width: CGFloat) -> CGFloat {
        guard string.count > 0 else { return 0 }
        let maxHeight: CGFloat = 10000
        let path = CGPath(rect: .init(x: 0, y: 0, width: width, height: maxHeight), transform: nil)
        let frame: CTFrame = ctFrame(for: path)
        let lines: [CTLine] = CTFrameGetLines(frame) as! [CTLine]

        var ascent: CGFloat = .zero
        var descent: CGFloat = .zero
        var leading: CGFloat = .zero
        CTLineGetTypographicBounds(lines[lines.count - 1], &ascent, &descent, &leading)
            
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        let last: CGPoint = origins[lines.count - 1]

        return ceil(maxHeight - last.y + descent) + 1
    }

    private func ctFrame(for path: CGPath) -> CTFrame {
        let cgpath = CGMutablePath()
        let rect: CGRect = path.boundingBox

        var tran = CGAffineTransform.identity
        tran = tran.translatedBy(x: rect.origin.x, y: rect.origin.y)
        tran = tran.scaledBy(x: 1, y: -1)
        tran = tran.translatedBy(x: rect.origin.x, y: -rect.height)
        cgpath.addPath(path, transform: tran)
        cgpath.move(to: .zero)
        cgpath.closeSubpath()

        return CTFramesetterCreateFrame(
            CTFramesetterCreateWithAttributedString(self),
            CFRangeMake(0, length),
            CGPath(rect: rect, transform: nil),
            nil
        )
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
            attributes[.paragraphStyle] = paragraphStyle
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
