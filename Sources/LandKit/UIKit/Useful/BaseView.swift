//
//  BaseView.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import UIKit

public enum ScreenUtils {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.statusBarHeight
    }
    
    static var safeAreaTop: CGFloat {
        return UIApplication.windowSafeAreaTop
    }
    
    static var safeAreaBottom: CGFloat {
        return UIApplication.windowSafeAreaBottom
    }
}

/// UI组件协议
protocol UIComponentsProtocol {
    /// 添加
    func addUIComponents()
    /// 布局
    func layoutUIComponents()
    /// 更新
    func updateUIComponents()
}

private typealias BaseView = LKBaseView & UIComponentsProtocol

private class LKBaseView: UIView {
    public let screenWidth: CGFloat = ScreenUtils.width
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupBusViews()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 创建业务视图

    func setupBusViews() {
        guard let view = self as? BaseView else { return }
        view.addUIComponents()
        view.layoutUIComponents()
    }
}
