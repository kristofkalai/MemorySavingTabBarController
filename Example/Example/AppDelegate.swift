//
//  AppDelegate.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .gray
        window?.makeKeyAndVisible()
        window?.rootViewController = RootViewController()
        return true
    }
}
