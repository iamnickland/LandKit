//
//  UIColor+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

public extension UIColor {
    convenience init?(hex: Int, alpha: Float = 1.0) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: Int(hex), alpha: alpha)
        } else {
            return nil
        }
    }
    
    /// make color
    /// - Parameters:
    ///   - hex: hex code
    ///   - alpha: alpha description
    /// - Returns: color
    static func hexColor(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.contains("#") {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        if cString.contains(" ") {
            cString = cString.replacingOccurrences(of: " ", with: "")
        }
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    private convenience init?(hex3: Int, alpha: Float) {
        self.init(red: CGFloat(((hex3 & 0xF00) >> 8).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex3 & 0x0F0) >> 4).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex3 & 0x00F) >> 0).duplicate4bits()) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int, alpha: Float?) {
        self.init(red: CGFloat(((hex4 & 0xF000) >> 12).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex4 & 0x0F00) >> 8).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex4 & 0x00F0) >> 4).duplicate4bits()) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat(((hex4 & 0x000F) >> 0).duplicate4bits()) / 255.0)
    }

    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0, alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int, alpha: Float?) {
        self.init(red: CGFloat((hex8 & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((hex8 & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((hex8 & 0x0000FF00) >> 8) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat((hex8 & 0x000000FF) >> 0) / 255.0)
    }
}

// MARK: - 关于颜色的常用函数

public extension UIColor {
    /// 通过颜色创建图片
    /// - Parameter size: 图片大小
    /// - Returns: 图片
    func toImage(size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    /// 通过颜色和圆角配置创建圆角图片
    /// - Parameters:
    ///   - size: 图片大小
    ///   - corners: 指定圆角角度
    ///   - radius: 圆角半径
    /// - Returns: 图片
    func toImage(size: CGSize = CGSize(width: 10, height: 10), corners: UIRectCorner = .allCorners, radius: CGFloat = 0) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            setFill()
            path.fill()
        } else {
            context?.setFillColor(cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        return img
    }
}
