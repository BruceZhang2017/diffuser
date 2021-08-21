//
//  DualModeTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBLEKit
import Toaster

let locations = ["Downstairs / Main Living", "Business", "Suite", "Custom"]

class DualModeViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var ssidTextField: MTextField!
    @IBOutlet weak var passwordTextField: MTextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var ssidView: UIView!
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var timeZoneValueLabel: UILabel!
    
    var homeID: Int64 = 0
    var deviceInfo: TYBLEAdvModel?
    var deviceModel: TuyaSmartDeviceModel?
    var showSearching = false
    
    // MARK: - Property
    private var isSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ssidTextField.text = UserDefaults.standard.string(forKey: "ssid")
        passwordTextField.text = UserDefaults.standard.string(forKey: "pwd")
        log.info("[配网] 开始配网")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showSearching {
            getConnecting(UIButton())
        }
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

    func searchTapped() {
        TuyaSmartBLEManager.sharedInstance().delegate = self
        log.info("[配网] 开始搜索")
        // Start finding un-paired BLE devices, it's the same process as single BLE mode.
        TuyaSmartBLEManager.sharedInstance().startListening(true)
        
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
    
    @IBAction func getConnecting(_ sender: Any) {
        searchView.isHidden = false
        startSearch()
        searchTapped()
        log.info("[配网] 开始连接")
    }
    
    @IBAction func connectWithSSIDAndPwd(_ sender: Any) {
        guard let ssid = ssidTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), ssid.count > 0 else {
            Toast(text: "请输入SSID").show()
            return
        }
        guard let pwd = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), pwd.count > 0 else {
            Toast(text: "请输入密码").show()
            return
        }
        UserDefaults.standard.setValue(ssid, forKey: "ssid")
        UserDefaults.standard.setValue(pwd, forKey: "pwd")
        UserDefaults.standard.synchronize()
        connectDevice()
        log.info("[配网] 开始指定ssid: \(ssid)")
    }
    @IBAction func continueWithConfi(_ sender: Any) {
        finishView.isHidden = false
    }
    
    @IBAction func finished(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("AddDevice"), object: nil)
        let vcs = navigationController?.viewControllers ?? []
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
        log.info("[配网] 完成配网")
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        Alert.showBasicAction(on: self,
                              with: "Diffuser Location",
                              message: "",
                              actions: [
                                UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                    
                                }),
                                UIAlertAction(title: locations[0], style: .default, handler: { [weak self] action in
                                    self?.locationValueLabel.text = locations[0]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 0], forKey: "location")
                                }),
                                UIAlertAction(title: locations[1], style: .default, handler: { [weak self] action in
                                    self?.locationValueLabel.text = locations[1]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 1], forKey: "location")
                                }),
                                UIAlertAction(title: locations[2], style: .default, handler: { [weak self] action in
                                    self?.locationValueLabel.text = locations[2]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 2], forKey: "location")
                                }),
                                UIAlertAction(title: locations[3], style: .default, handler: { [weak self] action in
                                    self?.locationValueLabel.text = locations[3]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 3], forKey: "location")
                                })]
        )
        log.info("[配网] 修改location")
    }
    
    @IBAction func changeTimezone(_ sender: Any) {
        Alert.showBasicAction(on: self,
                              with: "Time Zone",
                              message: "",
                              actions: [
                                UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                    
                                }),
                                UIAlertAction(title: "Mountain Standard Time", style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = "Mountain Standard Time"
                                }),
                                UIAlertAction(title: "Pacific Standard Time", style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = "Pacific Standard Time"
                                }),
                                UIAlertAction(title: "Eastern Standard Time", style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = "Eastern Standard Time"
                                })]
        )
        log.info("[配网] 修改time zone")
    }
    
    private func connectDevice() {
        // Found a BLE device, then try to config that using TuyaSmartBLEWifiActivator.
        guard let deviceInfo = deviceInfo else {
            return
        }
        TuyaSmartBLEWifiActivator.sharedInstance().bleWifiDelegate = self
        SVProgressHUD.show(withStatus: NSLocalizedString("Configuring", comment: ""))
        TuyaSmartBLEWifiActivator.sharedInstance().startConfigBLEWifiDevice(withUUID: deviceInfo.uuid, homeId: homeID, productId: deviceInfo.productId, ssid: ssidTextField.text ?? "", password: passwordTextField.text ?? "", timeout: 100) {
            log.info("[配网] Configuring")
        } failure: {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Failed to Send Data to the Device", comment: ""))
            log.info("[配网] Failed to Send Data to the Device")
        }
    }
}

extension DualModeViewController: TuyaSmartBLEManagerDelegate {
    
    // When the BLE detector finds one un-paired BLE device, this delegate method will be called.
    func didDiscoveryDevice(withDeviceInfo deviceInfo: TYBLEAdvModel) {
        log.info("[配网] 发现设备：\(deviceInfo)")
        guard let homeID = Home.current?.homeId else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("No Home Selected", comment: ""))
            log.info("[配网] No Home Selected")
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
        
        ssidView.isHidden = false
        self.homeID = homeID
        self.deviceInfo = deviceInfo
    }
    
    func bluetoothDidUpdateState(_ isPoweredOn: Bool) {
        log.info("[配网] bluetoothDidUpdateState：\(isPoweredOn)")
    }
    
    func onCentralDidDisconnect(fromDevice devId: String, error: Error) {
        log.info("[配网] onCentralDidDisconnect：\(devId)")
    }
    
    func bleManager(_ manager: TuyaSmartBLEManager, didFinishActivateDevice deviceModel: TuyaSmartDeviceModel, error: Error) {
        log.info("[配网] bleManager didFinishActivateDevice：\(deviceModel)")
    }
    
    func bleReceiveTransparentData(_ data: Data, devId: String) {
        log.info("[配网] bleReceiveTransparentData：\(data) \(devId)")
    }
}

extension DualModeViewController: TuyaSmartBLEWifiActivatorDelegate {
    
    // When the device connected to the router and activate itself successfully to the cloud, this delegate method will be called.
    func bleWifiActivator(_ activator: TuyaSmartBLEWifiActivator, didReceiveBLEWifiConfigDevice deviceModel: TuyaSmartDeviceModel?, error: Error?) {
        guard error == nil,
            let deviceModel = deviceModel else {
            log.info("[配网] ble和wifi配网报错：\(error)")
            return
        }
        log.info("[配网] ble和wifi配网成功")
        isSuccess = true
        self.deviceModel = deviceModel
        SVProgressHUD.dismiss()
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        present(vc, animated: true) {
            
        }
    }
}

extension DualModeViewController: LoadingViewDelegate {
    func callbackContinue() {
        configView.isHidden = false
    }
}
