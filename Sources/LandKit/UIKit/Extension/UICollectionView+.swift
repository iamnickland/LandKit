//
//  UICollectionView+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

public enum UCElementKindSection: String {
    case header = "elementKindSectionHeader"
    case footer = "elementKindSectionFooter"
}

public extension UICollectionView {
    // MARK: UICollectionViewCell
    func registerClass<T: UICollectionViewCell>(_ cellType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T)!
    }
    
    // MARK: UICollectionViewCell Nib
    func registerClass<T: UICollectionViewCell & NibBased>(_ cellType: T.Type, nibName: String? = nil, reuseIdentifier: String = T.reuseIdentifier) {
        let nib = nibName.let { UINib(nibName: $0, bundle: nil) } ?? T.nib
        register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCellClass<T: UICollectionViewCell & NibBased>(for indexPath: IndexPath, reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T)!
    }
    
    // MARK: UICollectionReusableView Header & Footer
    func registerHeaderFooterClass<T: UICollectionReusableView>(_ cellType: T.Type, kind: UCElementKindSection, reuseIdentifier: String = T.reuseIdentifier) {
        switch kind {
        case .header:
            register(cellType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        case .footer:
            register(cellType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooter<T: UICollectionReusableView>(for indexPath: IndexPath, kind: UCElementKindSection, reuseIdentifier: String = T.reuseIdentifier) -> T {
        switch kind {
        case .header:
            return (dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier, for: indexPath) as? T)!
        case .footer:
            return (dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier, for: indexPath) as? T)!
        }
    }
    
}

//public extension UICollectionViewCell {
//    static var reuseIdentifier: String {
//        String(describing: self)
//    }
//}

public extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
