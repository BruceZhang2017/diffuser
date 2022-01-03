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
        checkUpdate()
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
        LogManager.sharedInstance.setupLog() // 设置Log
        return true
    }
    
    private func setupCommon() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().tintColor = UIColor.hex(color: "BB9BC5")
    }
    
    private func checkUpdate() {
        let path = "http://itunes.apple.com/cn/lookup?id=1586015962"
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(url: url! as URL,cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,timeoutInterval: 10.0)
        request.httpMethod = "POST"
            
        NSURLConnection.sendAsynchronousRequest(request as URLRequest,queue: OperationQueue()) { (response,data,error) in
            let receiveStatusDic = NSMutableDictionary()
            if data != nil {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    print("获取到的数据：\(dic)")
                    if let resultCount = dic?["resultCount"] as? NSNumber {
                        if resultCount.intValue > 0 {
                            receiveStatusDic.setValue("1",forKey: "status")
                            if let arr = dic?["results"] as? NSArray {
                                if let dict = arr.firstObject as? NSDictionary {
                                    if let version = dict["version"] as? String {
                                        receiveStatusDic.setValue(version,forKey: "version")
                                        UserDefaults.standard.set(version,forKey: "Version")
                                        UserDefaults.standard.synchronize()
                                        let releaseNotes = dict["releaseNotes"] as! String
                                        UserDefaults.standard.set(releaseNotes,forKey: "releaseNotes")
                                        UserDefaults.standard.synchronize()
                                        let trackViewUrl = dict["trackViewUrl"] as! String
                                        UserDefaults.standard.set(trackViewUrl,forKey: "trackViewUrl")
                                        UserDefaults.standard.synchronize()
                                    }
                                }
                            }
                        }
                    }
                }catch let error {
                    log.debug("checkUpdate -------- \(error)")
                    receiveStatusDic.setValue("0",forKey: "status")
                }
            }else {
                receiveStatusDic.setValue("0",forKey: "status")
            }
            self.performSelector(onMainThread: #selector(self.checkUpdateWithData(_:)),with: receiveStatusDic,waitUntilDone: false)
        }
    }
        
    @objc func checkUpdateWithData(_ data: NSDictionary) {
        let status = data["status"] as? String
        let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        if status == "1" {
            let storeVersion = data["version"] as? String ?? "1.0.0"
            self.compareVersion(localVersion: localVersion,storeVersion: storeVersion)
            return
        }
        if let storeVersion = UserDefaults.standard.object(forKey: "Version") as? String {
            self.compareVersion(localVersion: localVersion,storeVersion: storeVersion)
        }
    }
    
    private func compareVersion(localVersion: String,storeVersion: String) {
        if localVersion.compare(storeVersion) == ComparisonResult.orderedAscending {
            //做你想做的事情
            showAlert()
        }
    }
    
    private func showAlert() {
        guard let notes = UserDefaults.standard.string(forKey: "releaseNotes") else {
            return
        }
        let alertViewController = UIAlertController(title: "App Upgrade", message: notes, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let urlString = UserDefaults.standard.string(forKey: "trackViewUrl") else {
                return
            }
            guard let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel)
        
        alertViewController.addAction(logoutAction)
        alertViewController.addAction(cancelAction)
        
        window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
}

