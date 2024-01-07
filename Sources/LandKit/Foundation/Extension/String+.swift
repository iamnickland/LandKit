//
//  String+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import Foundation
import UIKit

// MARK: - URL编解码

let KUrlCodingReservedCharacters = "!*'();:|@&=$,/?%#[]{}"
public extension String {
    /// URL编码
    /// - Returns: String
    func urlEncode() -> String? {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KUrlCodingReservedCharacters).inverted)! as String
    }

    /// URL解码
    /// - Returns: String
    func urlDecode() -> String? {
        return removingPercentEncoding as String?
    }
    
    /// 转码
    var encodedURL: URL? {
        guard let string = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: string)
    }
}

// MARK: - 布局相关宽高计算

public extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func height(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func size(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return size(withAttributes: fontAttributes)
    }
    
    /*
     func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
         let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
         let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
         return ceil(boundingBox.height)
     }
    
     func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
         let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
         let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
         return ceil(boundingBox.width)
     }
      */
}

// MARK: - 空格去除

public extension String {
    // 去掉首尾空格
    var removeHeadAndTailSpace: String {
        let whitespace = NSCharacterSet.whitespaces
        return trimmingCharacters(in: whitespace)
    }

    // 去掉首尾空格 包括后面的换行 \n
    var removeHeadAndTailSpacePro: String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: whitespace)
    }

    // 去掉所有空格
    var removeAllSapce: String {
        return replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    // 去掉所有换行
    var removeAllReturn: String {
        return replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
    }

    // 去掉首尾空格 后 指定开头空格数
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0 ..< num {
            beginSpace += " "
        }
        return beginSpace + removeHeadAndTailSpacePro
    }
}

// MARK: - Range 字符串切分截取

public extension String {
    /// 根据下标获取某个下标字符
    subscript(of index: Int) -> String {
        if index < 0 || index >= count {
            return ""
        }
        for (i, item) in enumerated() {
            if index == i {
                return "\(item)"
            }
        }
        return ""
    }

    /// 根据range获取字符串 a[1...3]
    subscript(r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[start ... end])
    }

    /// 根据range获取字符串 a[0..<2]
    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[start ..< end])
    }

    /// 根据range获取字符串 a[...2]
    subscript(r: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[startIndex ... end])
    }

    /// 根据range获取字符串 a[0...]
    subscript(r: PartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: count - 1)
        return String(self[start ... end])
    }

    /// 根据range获取字符串 a[..<3]
    subscript(r: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[startIndex ..< end])
    }

    /// 截取字符串: index 开始到结尾
    /// - Parameter index: 开始截取的index
    /// - Returns: string
    func subString(_ index: Int) -> String {
        guard index < count else {
            return ""
        }
        let start = self.index(endIndex, offsetBy: index - count)
        return String(self[start ..< endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - begin: 开始截取的索引
    ///   - count: 需要截取的个数
    /// - Returns: 字符串
    func substring(start: Int, _ count: Int) -> String {
        let begin = index(startIndex, offsetBy: max(0, start))
        let end = index(startIndex, offsetBy: min(count, start + count))
        return String(self[begin ..< end])
    }
}

// MARK: - 字符处理

public extension String {
    /// 是否包含字符
    func isContainLetters() -> Bool {
        let lettersCharacters = CharacterSet.letters
        let lettersRange = rangeOfCharacter(from: lettersCharacters)
        return lettersRange != nil
    }

    /// 是否包含数字
    func isContainNumbers() -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = rangeOfCharacter(from: decimalCharacters)
        return decimalRange != nil
    }

    /// 是否包含特殊字符
    func isContainSpecial() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: NSRegularExpression.Options())
        var isSpecial = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, count)) != nil {
            isSpecial = true
        } else {
            isSpecial = false
        }
        
        return isSpecial
    }
    
    /// 使用正则表达式替换
    /// - Parameters:
    ///   - pattern: 待替换的字符串
    ///   - with: 替换后的字符
    ///   - options: options description
    /// - Returns: 替换处理后的字符
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, count), withTemplate: with)
    }
}

// MARK: - 富文本转换

public extension String {
    /// 查找当前字符串中所制定的字符,并设定指定的颜色
    /// - Parameters:
    ///   - strings: 需要特殊修改的字符组
    ///   - color: 颜色
    ///   - font: 字体
    ///   - characterSpacing: 字符间距
    /// - Returns: 处理后的富文本字符串
    func attributedString(_ strings: [String], color: UIColor? = nil, font: UIFont? = nil, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            if let color = color {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }
            if let font = font {
                attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            }
        }
        guard let characterSpacing = characterSpacing else { return attributedString }
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    /// 转换为富文本
    /// - Parameters:
    ///   - font: 字体
    ///   - foregroundColor: 字体颜色
    ///   - backgroundColr: 背景色
    ///   - style: 样式
    /// - Returns: 转换处理后的富文本字符串
    func attributedString(font: UIFont, foregroundColor: UIColor, backgroundColr: UIColor? = nil, style: NSParagraphStyle? = nil) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: foregroundColor,
        ]
        if let backgroundColr = backgroundColr {
            attributes[.backgroundColor] = backgroundColr
        }
        if let paragraphStyle = style {
            attributes[.paragraphStyle] = paragraphStyle
        }
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        return attributedString
    }
}
