//
//  DualModeTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBLEKit

class DualModeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    
    // MARK: - Property
    private var isSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopConfiguring()
    }
    
    private func startSearch() {
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 5
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        searchImageView.layer.add(anim, forKey: nil)
    }

    @objc func searchTapped(_ sender: UIBarButtonItem) {
        TuyaSmartBLEManager.sharedInstance().delegate = self
        
        // Start finding un-paired BLE devices, it's the same process as single BLE mode.
        TuyaSmartBLEManager.sharedInstance().startListening(true)
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Searching", comment: ""))
        
    }
    
    // MARK: - Private method
    private func stopConfiguring() {
        if !isSuccess {
            SVProgressHUD.dismiss()
        }
        
        TuyaSmartBLEManager.sharedInstance().delegate = nil
        TuyaSmartBLEManager.sharedInstance().stopListening(true)
        
        TuyaSmartBLEWifiActivator.sharedInstance().bleWifiDelegate = nil
        TuyaSmartBLEWifiActivator.sharedInstance().stopDiscover()
    }
}

extension DualModeViewController: TuyaSmartBLEManagerDelegate {
    
    // When the BLE detector finds one un-paired BLE device, this delegate method will be called.
    func didDiscoveryDevice(withDeviceInfo deviceInfo: TYBLEAdvModel) {
        guard let homeID = Home.current?.homeId else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("No Home Selected", comment: ""))
            return
        }
        
        let type = deviceInfo.bleType
        
        guard
            type == TYSmartBLETypeBLEWifiSecurity ||
            type == TYSmartBLETypeBLEWifi ||
            type == TYSmartBLETypeBLELTESecurity
        else {
            return
        }
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Sending Data to the Device", comment: "Sending Data to the BLE Device"))
        
        // Found a BLE device, then try to config that using TuyaSmartBLEWifiActivator.
        
        TuyaSmartBLEWifiActivator.sharedInstance().bleWifiDelegate = self
        
        TuyaSmartBLEWifiActivator.sharedInstance().startConfigBLEWifiDevice(withUUID: deviceInfo.uuid, homeId: homeID, productId: deviceInfo.productId, ssid: ssidTextField.text ?? "", password: passwordTextField.text ?? "", timeout: 100) {
            SVProgressHUD.show(withStatus: NSLocalizedString("Configuring", comment: ""))
        } failure: {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Failed to Send Data to the Device", comment: ""))
        }

    }
}

extension DualModeViewController: TuyaSmartBLEWifiActivatorDelegate {
    
    // When the device connected to the router and activate itself successfully to the cloud, this delegate method will be called.
    func bleWifiActivator(_ activator: TuyaSmartBLEWifiActivator, didReceiveBLEWifiConfigDevice deviceModel: TuyaSmartDeviceModel?, error: Error?) {
            guard error == nil,
                  let deviceModel = deviceModel else {
                return
            }
            
            let name = deviceModel.name ?? NSLocalizedString("Unknown Name", comment: "Unknown name device.")
            
            SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Successfully Added \(name)", comment: "Successfully added one device."))
            isSuccess = true
            self.navigationController?.popViewController(animated: true)
    }
}
