//
//  AppDelegate.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.global.appearance = .dark
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let navigationController = UINavigationController(navigationBarClass: AppearanceNavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [ChartsViewController()]
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
        
        return true
    }
}

