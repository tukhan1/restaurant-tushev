//
//  AppDelegate.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 24.10.2023.
//

import UIKit
import Firebase
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = CustomTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

