//
//  DeviceMainViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import SnapKit

class DeviceMainViewController: BaseViewController {
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    @IBOutlet weak var nullView: UIView!
    var deviceList:  DeviceListTableViewController!
    var settingsVC: SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabHeight.constant = UIDevice.isSameToIphoneX() ? 83 : 50
        let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
        deviceList = storyboard.instantiateViewController(withIdentifier: "DeviceListTableViewController") as? DeviceListTableViewController
        view.addSubview(deviceList.view)
        addChild(deviceList)
        deviceList.view.snp.makeConstraints {
            $0.edges.equalTo(nullView)
        }
        deviceList.view.isHidden = true 
        
        settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsTableViewController") as? SettingsTableViewController
        view.addSubview(settingsVC.view)
        addChild(settingsVC)
        settingsVC.view.snp.makeConstraints {
            $0.edges.equalTo(nullView)
        }
        settingsVC.view.isHidden = true
        
        view.bringSubviewToFront(tabView)
    }
    
    @IBAction private func handleShowDeviceList(_ sender: Any) {
        settingsVC.view.isHidden = true
        deviceList.view.isHidden = false
    }
    
    @IBAction private func handleShowSettings(_ sender: Any) {
        settingsVC.view.isHidden = false
        deviceList.view.isHidden = true
    }

}

public extension UIDevice {
    // 判断手机是否IPONEX类型
    static func isSameToIphoneX() -> Bool {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                if (window?.safeAreaInsets.bottom ?? 0) > 0 {
                    return true
                }
            }
        }
        return false
    }
}
