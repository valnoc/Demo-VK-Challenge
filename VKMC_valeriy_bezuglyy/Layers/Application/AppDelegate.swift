//
//  AppDelegate.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit
import VKSdkFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appFactory: AppFactory!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        appFactory = AppFactory()
        let vcFactory = appFactory.makeVCFactory()
        window.rootViewController = vcFactory.makeFeedViewController()
        
        return true
    }

    // MARK: -
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let app = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            let authService = appFactory.makeAuthService() as? VKAuthService {
            return authService.processOpenUrl(url, by: app)
        }
        return false
    }
}

