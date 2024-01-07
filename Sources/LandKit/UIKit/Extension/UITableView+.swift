//
//  UITableViewCell+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

public extension UITableView {
    
    // MARK: - UITableViewCell
    func registerCell<T: UITableViewCell>(_: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCellClass<T: UITableViewCell>(for indexPath: IndexPath, reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T)!
    }
    
    // MARK: - UITableViewCell Nib
    func registerCell<T: UITableViewCell & NibBased>(_: T.Type, nibName: String? = nil, reuseIdentifier: String = T.reuseIdentifier) {
        let nib = nibName.let { UINib(nibName: $0, bundle: nil) } ?? T.nib
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCellClass<T: UITableViewCell & NibBased>(for indexPath: IndexPath, reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T)!
    }
    
    // MARK: UITableViewHeaderFooterView
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableHeaderFooterViewClass<T: UITableViewHeaderFooterView>(reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T)!
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
   static var reuseIdentifier: String {
       String(describing: self)
   }

}
