//
//  NSAttributedString+.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation
import UIKit

public extension NSAttributedString {
    /// 计算高度
    func height(font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        label.numberOfLines = 0
        label.font = font
        label.attributedText = self
        
        label.sizeToFit()
        return label.frame.height
    }
}
