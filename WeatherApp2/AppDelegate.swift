//
//  AppDelegate.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let initialViewControllerName = "WelcomePage"
    private var initialViewController: UIViewController{
        let storyboard = UIStoryboard(name: initialViewControllerName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        return viewController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let navigationController = UINavigationController(rootViewController: self.initialViewController)
        navigationController.navigationBar.barTintColor = UIColor.init(red: 0, green: 0.6, blue: 0.8392, alpha: 1.0)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        navigationController.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}
