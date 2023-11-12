//
//  UIViewController+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 07.11.2023.
//

import Foundation

import UIKit

extension UIViewController {
    
    func presentErrorAlert(withMessage message: String = "Что-то пошло не так. Пожалуйста, попробуйте еще раз.") {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
