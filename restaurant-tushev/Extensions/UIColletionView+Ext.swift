//
//  UIColletionView+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 27.10.2023.
//

import UIKit

protocol ReusableView {
    static var cellIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.cellIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.cellIdentifier)")
        }
        return cell
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.cellIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.cellIdentifier)")
        }
        return cell
    }
}
