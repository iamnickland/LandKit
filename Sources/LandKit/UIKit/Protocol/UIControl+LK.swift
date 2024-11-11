//
//  UIControl+LK.swift
//
//
//  Created by Anakin on 2024/7/31.
//

import Foundation
import UIKit

/// UIControl闭包
public typealias ControlClosure = (UIControl) -> Void

// MARK: - UIView + LKPOPCompatible

extension UIView: LKPOPCompatible {}

// MARK: - AssociateKeys

private struct AssociateKeys {
    // 使用 ptr 进行操作
    static var closure = UnsafeRawPointer("UIControlclosure".withCString { $0 })
}

// MARK: - 防止按钮重复点击

public extension LKPOP where Base: UIControl {
    // MARK: 多少秒内不可重复点击

    // 多少秒内不可重复点击
    func preventDoubleHit(_ hitTime: Double = 1) {
        base.preventDoubleHit(hitTime)
    }
    
    /// UIControl 添加回调方式
    func addActionHandler(_ action: @escaping ControlClosure, for controlEvents: UIControl.Event = .touchUpInside) {
        base.addTarget(self, action: #selector(base.handleAction), for: controlEvents)
        objc_setAssociatedObject(base, &AssociateKeys.closure, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

private var hitTimerKey: Void?
private extension UIControl {
    private var hitTime: Double? {
        get { return lk_getAssociatedObject(self, &hitTimerKey) }
        set { lk_setRetainedAssociatedObject(self, &hitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func preventDoubleHit(_ hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_preventDoubleHit), for: .touchUpInside)
    }
    
    @objc func c_preventDoubleHit(_ base: UIControl) {
        base.isUserInteractionEnabled = false
        LKAsyncs.asyncDelay(hitTime ?? 1.0) {} _: {
            base.isUserInteractionEnabled = true
        }
    }
    
    /// 点击回调
    @objc func handleAction(_ sender: UIControl) {
        if let block = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ControlClosure {
            block(sender)
        }
    }
}

// MARK: - UIButton + LKPOPCompatible

private var LKUIButtonExpandSizeKey = UnsafeRawPointer("LKUIButtonExpandSizeKey".withCString { $0 })
// 扩大按钮点击区域
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if lk.touchExtendInset == .zero || isHidden || !isEnabled {
            return super.point(inside: point, with: event)
        }
        var hitFrame = bounds.inset(by: lk.touchExtendInset)
        hitFrame.size.width = max(hitFrame.size.width, 0)
        hitFrame.size.height = max(hitFrame.size.height, 0)
        return hitFrame.contains(point)
    }
}

public extension LKPOP where Base: UIButton {
    // MARK: 扩大UIButton的点击区域，向四周扩展10像素的点击范围

    /// 扩大按钮点击区域 如UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)将点击区域上下左右各扩充50
    ///
    /// 提示：theView 扩展点击相应区域时，其扩展的区域不能超过 superView 的 frame ，否则不会相应改点击事件；如果需要响应点击事件，需要对其 superView 进行和 theView 进行同样的处理
    var touchExtendInset: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(base, &LKUIButtonExpandSizeKey) {
                var edgeInsets = UIEdgeInsets.zero
                (value as AnyObject).getValue(&edgeInsets)
                return edgeInsets
            } else {
                return UIEdgeInsets.zero
            }
        }
        set {
            objc_setAssociatedObject(base, &LKUIButtonExpandSizeKey, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
