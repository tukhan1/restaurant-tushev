//
//  UIView+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
