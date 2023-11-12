//
//  CustomTabBar.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit

class CustomTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let mainVC = MainVC(nibName: nil, bundle: nil)
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        let orderVC = OrderVC(nibName: nil, bundle: nil)
        orderVC.tabBarItem = UITabBarItem(title: "Доставка", image: UIImage(systemName: "cup.and.saucer.fill"), selectedImage: UIImage(systemName: "cup.and.saucer.fill"))
        let profileVC = ProfileVC(nibName: nil, bundle: nil)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        let mainNavController = UINavigationController(rootViewController: mainVC)
        let orderNavController = UINavigationController(rootViewController: orderVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [mainNavController, orderNavController, profileNavController]
    }
}
