//
//  AppDelegate.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize TuyaSmartSDK
        TuyaSmartSDK.sharedInstance().start(withAppKey: AppKey.appKey, secretKey: AppKey.secretKey)
        IQKeyboardManager.shared.enable = true
        // Enable debug mode, which allows you to see logs.
        #if DEBUG
        TuyaSmartSDK.sharedInstance().debugMode = true
        #endif
        
        SVProgressHUD.setDefaultStyle(.dark)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        setupCommon()
        if TuyaSmartUser.sharedInstance().isLogin {
            // User has already logged, launch the app with the main view controller.
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            // There's no user logged, launch the app with the login and register view controller.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    private func setupCommon() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().tintColor = UIColor.hex(color: "BB9BC5")
    }
}

