//
//  NibBased.swift
//  LandKit
//
//  Created by Nick Land on 2023/7/21.
//

import Foundation
import UIKit

public protocol NibBased {
    // MARK: Static parameters

    static var nibName: String { get }
}

public extension NibBased {
    // MARK: Static parameters

    static var nibName: String {
        String(describing: self)
    }
}

public extension NibBased where Self: UIView {
    // MARK: Static functions

    static func instantiate(owner: Any? = nil) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        let items = nib.instantiate(withOwner: owner, options: nil)
        return (items.first! as? Self)!
    }
}

public extension NibBased where Self: UIViewController {
    // MARK: Static functions

    static func instantiate() -> Self {
        Self(nibName: nibName, bundle: Bundle(for: self))
    }
}

public extension NibBased where Self: UITableViewController {
    // MARK: Static functions

    static func instantiate() -> Self {
        Self(nibName: nibName, bundle: Bundle(for: self))
    }
}

public extension NibBased where Self: UICollectionViewCell {
    // MARK: Static properties

    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}

public extension NibBased where Self: UITableViewCell {
    // MARK: Static properties

    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}
