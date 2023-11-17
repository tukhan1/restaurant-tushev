//
//  UIApplication+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 12.11.2023.
//

import UIKit

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
