//
//  UIImage+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

// MARK: - LKImageGradientDirection

public enum LKImageGradientDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
    case toBottomLeft
    case toBottomRight
    case toTopLeft
    case toTopRight
}

/// 渐变图片
public extension UIImage {
    convenience init?(size: CGSize, direction: LKImageGradientDirection, colors: [UIColor]) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil } // If the size is zero, the context will be nil.
        guard colors.count >= 1 else { return nil } // If less than 1 color, return nil
        if colors.count == 1 {
            // Mono color
            let color = colors.first!
            color.setFill()
            
            let rect = CGRect(origin: CGPoint.zero, size: size)
            UIRectFill(rect)
        } else {
            // Gradient color
            var locations: [CGFloat] = []
            
            for (index, _) in colors.enumerated() {
                let index = CGFloat(index)
                locations.append(index / CGFloat(colors.count - 1))
            }
            
            guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: colors.compactMap { $0.cgColor.components }.flatMap { $0 }, locations: locations, count: colors.count) else {
                return nil
            }
            
            var startPoint: CGPoint
            var endPoint: CGPoint
            
            switch direction {
            case .toLeft:
                startPoint = CGPoint(x: size.width, y: size.height / 2)
                endPoint = CGPoint(x: 0.0, y: size.height / 2)
            case .toRight:
                startPoint = CGPoint(x: 0.0, y: size.height / 2)
                endPoint = CGPoint(x: size.width, y: size.height / 2)
            case .toTop:
                startPoint = CGPoint(x: size.width / 2, y: size.height)
                endPoint = CGPoint(x: size.width / 2, y: 0.0)
            case .toBottom:
                startPoint = CGPoint(x: size.width / 2, y: 0.0)
                endPoint = CGPoint(x: size.width / 2, y: size.height)
            case .toBottomLeft:
                startPoint = CGPoint(x: size.width, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: size.height)
            case .toBottomRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: size.width, y: size.height)
            case .toTopLeft:
                startPoint = CGPoint(x: size.width, y: size.height)
                endPoint = CGPoint(x: 0.0, y: 0.0)
            case .toTopRight:
                startPoint = CGPoint(x: 0.0, y: size.height)
                endPoint = CGPoint(x: size.width, y: 0.0)
            }
            
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        }
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
    
    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
}

/// 根据颜色生成图片
public extension UIImage {
    /// 通过颜色生成图片
    static func createImage(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
    
    /// 通过颜色,尺寸,圆角创建图片
    static func createImage(color: UIColor, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        let image = createImage(color: color, size: size)
        let newImage = image.roundedCorners(radius: cornerRadius)
        return newImage ?? image
    }

    /// 将图片裁剪为圆角
    func roundedCorners(radius: CGFloat? = 0.0) -> UIImage {
        var cornerRadius: CGFloat = 0.0
        if let radius = radius, radius > 0 {
            let maxRadius = min(size.width, size.height) / 2
            cornerRadius = min(radius, maxRadius)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
   
        return image ?? self
    }
}

// MARK: - UIColor 生成的图片 和 生成渐变色图片

public extension UIImage {
    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return image(color: color, size: size, corners: .allCorners, radius: 0)
    }

    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - corners: 剪切的方式
    ///   - round: 圆角大小
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        if radius > 0.0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        return img
    }

    enum GradientDirection {
        case horizontal // 水平从左到右
        case vertical // 垂直从上到下
        case leftOblique // 左上到右下
        case rightOblique // 右上到左下
        case other(CGPoint, CGPoint)
    
        public func point(size: CGSize) -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
            case .vertical:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
            case let .other(stat, end):
                return (stat, end)
            }
        }
    }

    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), radius: CGFloat, locations: [CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        if colors.isEmpty { return nil }
        if colors.count == 1 {
            return UIImage.image(color: colors[0], size: size)
        }
        let directionPoint = direction.point(size: size)
        return gradient(colors, size: size, radius: radius, locations: locations, startPoint: directionPoint.0, endPoint: directionPoint.1)
    }
    
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), radius: CGFloat, locations: [CGFloat]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> UIImage? {
        if colors.isEmpty { return nil }
        if colors.count == 1 {
            return UIImage.image(color: colors[0], size: size)
        }
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map { $0.cgColor } as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil }
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
