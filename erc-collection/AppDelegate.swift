//
//  AppDelegate.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let navigationController = UINavigationController()

    lazy var rootCoordinator: RootCoordinator = .init(navigationController: navigationController)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()

        rootCoordinator.start()

        return true
    }
}
