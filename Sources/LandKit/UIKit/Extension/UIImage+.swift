//
//  UIImage+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import UIKit

public extension UIImage {
    
    /// 通过颜色生成图片
    static func creatImage(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 讲图片裁剪为圆角
    func roundedCorners(radius: CGFloat? = 0.0) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 通过颜色,尺寸,圆角创建图片
    static func createImage(color: UIColor, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        let image = creatImage(color: color, size: size)
        let newImage = image.roundedCorners(radius: cornerRadius)
        return newImage ?? image
    }
}
