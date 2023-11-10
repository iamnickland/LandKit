//
//  BaseTableViewCell.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import UIKit

typealias BaseTableViewCell = LKBaseTableViewCell & UIComponentsProtocol

class LKBaseTableViewCell: UITableViewCell {
    class var cellIdentifier: String {
        return String(describing: self)
    }
    
    public let screenWidth: CGFloat = ScreenUtils.width
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIComponents()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    func setupUIComponents() {
        guard let view = self as? BaseTableViewCell else {
            return
        }

        view.addUIComponents()
        view.layoutUIComponents()
    }
    
    public func updateUIComponents() {}
}
