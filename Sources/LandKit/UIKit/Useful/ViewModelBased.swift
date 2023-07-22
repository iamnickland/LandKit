//
//  ViewModelBased.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation
import UIKit

public protocol ViewModelBased {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
}

// MARK: 带VM的构造函数(代码)

public extension ViewModelBased where Self: UIView {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType) -> Self {
        var view = Self(frame: .zero)
        view.viewModel = viewModel
        return view
    }
}

public extension ViewModelBased where Self: UIViewController {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType) -> Self {
        var viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }
}

public extension ViewModelBased where Self: UITableViewController {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType, style: UITableView.Style) -> Self {
        var viewController = Self(style: style)
        viewController.viewModel = viewModel
        return viewController
    }
}

public extension ViewModelBased where Self: UICollectionViewController {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType, layout: UICollectionViewLayout) -> Self {
        var viewController = Self(collectionViewLayout: layout)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: 带VM的构造函数(NIB)

public extension ViewModelBased where Self: UIViewController, Self: NibBased {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType) -> Self {
        var viewController = Self(nibName: nibName, bundle: Bundle(for: self))
        viewController.viewModel = viewModel
        return viewController
    }
}

public extension ViewModelBased where Self: UITableViewController, Self: NibBased {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType) -> Self {
        var viewController = Self(nibName: nibName, bundle: Bundle(for: self))
        viewController.viewModel = viewModel
        return viewController
    }
}

public extension ViewModelBased where Self: UICollectionViewController, Self: NibBased {
    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType) -> Self {
        var viewController = Self(nibName: nibName, bundle: Bundle(for: self))
        viewController.viewModel = viewModel
        return viewController
    }
}
