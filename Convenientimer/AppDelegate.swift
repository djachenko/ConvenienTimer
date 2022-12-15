//
//  AppDelegate.swift
//  Convenientimer
//
//  Created by justin on 12.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = ViewController()

        let presenter = Presenter(
                view: viewController,
                alertService: AlertService(),
                historyService: HistoryService()
        )

        viewController.presenter = presenter


        window?.rootViewController = viewController

        window?.makeKeyAndVisible()

        return true
    }
}

