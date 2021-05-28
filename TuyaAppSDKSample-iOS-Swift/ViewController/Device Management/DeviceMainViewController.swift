//
//  DeviceMainViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import SnapKit
import AVFoundation
import AVKit

class DeviceMainViewController: BaseViewController {
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    @IBOutlet weak var nullView: UIView!
    var deviceList:  DeviceListTableViewController! // 设备列表
    var settingsVC: SettingsTableViewController! // 设置页面
    
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
    
    @IBAction private func handleConnectMyDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
        vc?.scanResultDelegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }

    @IBAction private func watchtutorail(_ sender: Any) {
        let player = AVPlayer(url: URL(string: "https://vd2.bdstatic.com//mda-ki5mbenfqf5hkpxn//mda-ki5mbenfqf5hkpxn.mp4?playlist=%5B%22hd%22%2C%22sc%22%5D&v_from_s=gz_haokan_4469&auth_key=1622043474-0-0-cdc5be81808e389dfacd496383d6a6f6&bcevod_channel=searchbox_feed&pd=1&pt=3&abtest=3000165_2")!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true, completion: nil)
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

extension DeviceMainViewController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        NSLog("scanResult:\(scanResult)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            [weak self] in
            let sb = UIStoryboard(name: "DualMode", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DualModeTableViewController")
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
