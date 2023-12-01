//
//  UIApplication+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import UIKit

public extension UIApplication {
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    /// 获取window顶部安全区高度: 44
    static var windowSafeAreaTop: CGFloat {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        if #available(iOS 15.0, *) {
            return window?.windowScene?.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return window?.safeAreaInsets.top ?? 0
        }
    }
    
    /// 获取window底部安全区高度 34
    static var windowSafeAreaBottom: CGFloat {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        if #available(iOS 15.0, *) {
            return window?.windowScene?.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return window?.safeAreaInsets.bottom ?? 0
        }
    }
}

public extension UIApplication {
    var keyWindowRootViewController: UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    }

    /// 获取顶部有效视图控制器
    /// - Parameter base: 所在的基础视图控制器
    /// - Returns: 视图控制器
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindowRootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
