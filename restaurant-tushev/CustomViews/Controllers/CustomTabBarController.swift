//
//  CustomTabBarController.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit

class CustomTabBarController: UITabBarController {
    
    let miniCartView = MiniCartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupMiniCartView()
        observeCartUpdates()
        updateCartVisibility()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(miniCartTapped))
        miniCartView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupViewControllers() {
        let mainVC = MainVC(nibName: nil, bundle: nil)
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        
        let profileVC = ProfileVC(nibName: nil, bundle: nil)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        let mainNavController = UINavigationController(rootViewController: mainVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [mainNavController, profileNavController]
    }
    
    private func setupMiniCartView() {
        view.addSubview(miniCartView)
        
        miniCartView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalTo(view.snp.left).offset(15)
            make.right.equalTo(view.snp.right).inset(15)
            make.bottom.equalTo(tabBar.snp.top)
        }
    }
    
    private func observeCartUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
    @objc private func cartUpdated() {
        miniCartView.updateTotalPrice()
        updateCartVisibility()
    }
    
    private func updateCartVisibility() {
        if CartManager.shared.items.isEmpty {
            miniCartView.hideCart()
        } else {
            miniCartView.showCart()
        }
    }
    
    @objc private func miniCartTapped() {
        showCartScreen()
    }
    
    private func showCartScreen() {
        // Create and present the CartViewController
        let cartVC = CartVC(products: CartManager.shared.items) // Initialize your CartViewController
        if let navController = selectedViewController as? UINavigationController {
            navController.pushViewController(cartVC, animated: true)
        }
    }
}
