//
//  UIWindow.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import UIKit

public extension UIWindow {
    static var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
}
