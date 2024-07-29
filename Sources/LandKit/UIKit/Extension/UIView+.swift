//
//  UIView+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

@IBDesignable public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

// MARK: - 阴影

public extension UIView {
    func makeShadow(cornerRadius: CGFloat = 10, shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.1), shadowOffset: CGSize = CGSize(width: 0.0, height: 6.0), shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - 边框和圆角

public extension UIView {
    /// 创建圆角
    /// `let corner: UIRectCorner = .bottomLeft.union(.bottomRight)`
    /// `view.roundCorners(corner, radius: 20)`
    /// - Parameters:
    ///   - corners: 需要圆角的方向
    ///   - radius: 圆角半径
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - LKBorderCorner

/// 边框拐角方位
public enum LKBorderCorner {
    case top, bottom, left, right
}

// MARK: - LKRectCornerRadius

/// 拐角半径大小
public struct LKRectCornerRadius {
    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat
    
    public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public init(all cornerRadius: CGFloat) {
        topLeft = cornerRadius
        topRight = cornerRadius
        bottomLeft = cornerRadius
        bottomRight = cornerRadius
    }
}

/// 边框及圆角
public extension UIView {
    /// 给视图增加边框
    /// - Parameters:
    ///   - corner: 边框方位
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func makeBorder(_ corner: LKBorderCorner, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        
        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        
        switch corner {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
    
    /// 可以灵活指定四个方位的圆角
    /// - Parameters:
    ///   - corners: 圆角大小
    ///   - frame: 位置大小
    func makeCorner(_ corners: LKRectCornerRadius, frame: CGRect? = nil) {
        let rect: CGRect = frame ?? bounds
        // 绘制路径
        let path = CGMutablePath()
        let topLeftRadius = corners.topLeft
        let topLeftCenter = CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius)
        path.addArc(center: topLeftCenter, radius: topLeftRadius, startAngle: Double.pi, endAngle: Double.pi * 1.5, clockwise: false)
        let topRightRadius = corners.topRight
        let topRightCenter = CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius)
        path.addArc(center: topRightCenter, radius: topRightRadius, startAngle: Double.pi * 1.5, endAngle: Double.pi * 2, clockwise: false)
        let bottomRightRadius = max(corners.bottomRight, 0)
        let bottomRightCenter = CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius)
        path.addArc(center: bottomRightCenter, radius: bottomRightRadius, startAngle: 0, endAngle: Double.pi * 0.5, clockwise: false)
        let bottomLeftRadius = max(corners.bottomLeft, 0)
        let bottomLeftCenter = CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius)
        path.addArc(center: bottomLeftCenter, radius: bottomLeftRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi, clockwise: false)
        path.closeSubpath()
        // 给layer添加遮罩
        let layer = CAShapeLayer()
        layer.path = path
        self.layer.mask = layer
    }
}

// MARK: - 给视图增加点击事件

public extension UIView {
    private static var blockKey = "UITapgestureBlockKey"
    
    /// 为View添加UITapGestureRecognizer事件
    /// - Parameters:
    ///   - handler: 点击回调
    /// - Returns: UITapGestureRecognizer
    @discardableResult
    func addTap(handler: @escaping ((_ sender: UITapGestureRecognizer) -> Void)) -> UITapGestureRecognizer {
        isUserInteractionEnabled = true
        let target = _UITapgestureBlockTarget(handler: handler)
       
        objc_setAssociatedObject(self, &UIView.blockKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tap = UITapGestureRecognizer(target: target, action: #selector(_UITapgestureBlockTarget.invoke(_:)))
        addGestureRecognizer(tap)
        return tap
    }
    
    private class _UITapgestureBlockTarget {
        private var handler: (_ sender: UITapGestureRecognizer) -> Void
        init(handler: @escaping (_ sender: UITapGestureRecognizer) -> Void) {
            self.handler = handler
        }

        @objc func invoke(_ sender: UITapGestureRecognizer) {
            handler(sender)
        }
    }
}
