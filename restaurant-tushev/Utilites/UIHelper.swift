//
//  UIHelper.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit

enum UIHelper {
    static func createTwoColumn(in rect: CGRect) -> CGSize {
        let widht = rect.width
        let padding: CGFloat = 10
        let minimumItemSpacing: CGFloat = 10
        let avalibleWidth = widht - padding - (minimumItemSpacing * 2)
        let itemWidht = avalibleWidth / 2
        return CGSize(width: itemWidht, height: itemWidht * 1.5)
    }
}
