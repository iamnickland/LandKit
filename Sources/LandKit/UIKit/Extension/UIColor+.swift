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
        if (0x000000 ... 0xFFFFFF) ~= hex { self.init(hex6: Int(hex), alpha: alpha) } else {
            return nil
        }
    }
 
    /// 根据RGBA的颜色(方法)
    /// - Parameters:
    ///   - r: red 颜色值
    ///   - g: green颜色值
    ///   - b: blue颜色值
    ///   - alpha: 透明度
    /// - Returns: 返回 UIColor
    ///
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
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

// MARK: -  获取UIColor的HSV/HSB值（Hue色相、S饱和度、B亮度）

/**
 在平时开发中我们使用的都是 RGB 颜色模式，即通过红、绿、蓝三原色来表示一种颜色。RGB 是对机器很友好的色彩模式，但并不够人性化。
     相对于 RGB，还有种 HSB（也叫 HSV）颜色模式，该模式更便于描述人眼对与颜色的感觉。使用该模式可以很明确的表达是什么颜色？鲜艳不鲜艳？亮还是暗？
 1，HSB 模式介绍
 HSB 又称 HSV，表示一种颜色模式。在 HSB 模式中，颜色由如下三种值组成：
 H（hue）代表色相：色相指色彩的种类和名称。如红、橙、黄.... 取值范围 0°~360°，每个角度可以代表一种颜色。
 S（saturation）表示饱和度：它用 0% 至 100% 的值描述了相同色相、明度下色彩纯度的变化。数值越大，颜色中的灰色越少，颜色越鲜艳，呈现一种从灰度到纯色的变化。
 B（brightness）表示亮度：其作用是控制色彩的明暗变化。它同样使用了 0% 至 100% 的取值范围。数值越小，色彩越暗，越接近于黑色；数值越大，色彩越亮，越接近于白色。
 */
public extension UIColor {
    // MARK: 5.1、返回HSBA模式颜色值

    // 返回HSBA模式颜色值
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        /**
         hue：色相
         saturation：饱和度
         brightness：亮度
         alpha：透明度
         */
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h * 360, s, b, a)
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
