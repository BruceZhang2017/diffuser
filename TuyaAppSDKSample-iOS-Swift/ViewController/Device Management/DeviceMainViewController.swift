//
//  DeviceMainViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import SnapKit
import AVFoundation
import AVKit
import CoreLocation
import TuyaSmartDeviceKit

class DeviceMainViewController: BaseViewController {
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    @IBOutlet weak var nullView: UIView!
    var deviceList:  DeviceListTableViewController! // 设备列表
    var settingsVC: SettingsTableViewController! // 设置页面
    private let homeManager = TuyaSmartHomeManager()
    let locationManager = CLLocationManager()
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleScent(_:)), name: Notification.Name("DeviceMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddDevice(_:)), name: Notification.Name("AddDevice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifi(_:)), name: Notification.Name("Main"), object: nil)
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
        
        if Home.current == nil {
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            } else {
                Alert.showBasicAlert(on: self, with: NSLocalizedString("Cannot Access Location", comment: ""), message: NSLocalizedString("Please make sure if the location access is enabled for the app.", comment: ""))
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func showRightNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addDevice))
    }
    
    public func hideRightNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc private func addDevice() {
        let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
        vc?.scanResultDelegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func handleShowDeviceList(_ sender: Any) {
        let count = deviceList?.home?.deviceList.count ?? 0
        settingsVC.view.isHidden = true
        deviceList.view.isHidden = count == 0
        if count > 0 {
            showRightNavigationButton()
        } else {
            hideRightNavigationButton()
        }
        
    }
    
    @IBAction private func handleShowSettings(_ sender: Any) {
        settingsVC.view.isHidden = false
        deviceList.view.isHidden = true
        hideRightNavigationButton()
    }
    
    @objc private func handleNotifi(_ notification: Notification) {
        let obj = notification.object as? Int ?? 0
        if obj == 0 {
            handleShowDeviceList(deviceButton!)
        } else {
            handleShowSettings(settingsButton!)
        }
    }
    
    @IBAction private func handleConnectMyDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
        vc?.scanResultDelegate = self
        navigationController?.pushViewController(vc!, animated: true)
        
        if Home.current == nil {
            homeManager.addHome(withName: "MyRoom", geoName: "Shenzhen", rooms: [""], latitude: latitude, longitude: longitude) { [weak self] _ in
                self?.homeManager.getHomeList { (homeModels) in
                    if homeModels?.count ?? 0 > 0  {
                        Home.current = homeModels?.first
                    }
                } failure: { (error) in
                
                }
            } failure: { (error) in
            }
        }
    }

    @IBAction private func watchtutorail(_ sender: Any) {
        let player = AVPlayer(url: URL(string: "https://vd2.bdstatic.com//mda-ki5mbenfqf5hkpxn//mda-ki5mbenfqf5hkpxn.mp4?playlist=%5B%22hd%22%2C%22sc%22%5D&v_from_s=gz_haokan_4469&auth_key=1622043474-0-0-cdc5be81808e389dfacd496383d6a6f6&bcevod_channel=searchbox_feed&pd=1&pt=3&abtest=3000165_2")!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true, completion: nil)
    }
    
    @objc public func handleScent(_ notification: Notification) {
        let obj = notification.object as? String ?? ""
        let row = deviceList?.currentDeviceRow ?? 0
        guard let deviceModel = deviceList?.home?.deviceList[row] else { return }
        var cache = UserDefaults.standard.dictionary(forKey: "Scent") as? [String: String] ?? [:]
        cache[deviceModel.devId] = obj
        UserDefaults.standard.setValue(cache, forKey: "Scent")
        UserDefaults.standard.synchronize()
        deviceList?.tableView.reloadData()
    }
    
    @objc public func handleAddDevice(_ notification: Notification) {
        deviceList?.loadData()
    }
    
    private func publishMessage(with dps: NSDictionary, device: TuyaSmartDevice) {
        guard let dps = dps as? [AnyHashable : Any] else { return }
        device.publishDps(dps, success: {
        }, failure: { (error) in
        })
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
    func scanFinished(scanResult: LBXScanResult, error: String?, type: Int) {
        NSLog("scanResult:\(scanResult)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            [weak self] in
            if type == 1 {
                let sb = UIStoryboard(name: "DeviceList", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "AddScentViewController") as? AddScentViewController
                let value = scanResult.strScanned?.lowercased() ?? "0"
                for (key, item) in scentPNG {
                    let i = item.replacingOccurrences(of: "-product-image-min", with: "")
                    if value.contains(i.lowercased()) {
                        vc?.scent = key
                        break
                    }
                }
                self?.navigationController?.pushViewController(vc!, animated: true)
                return
            }
            let sb = UIStoryboard(name: "DualMode", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DualModeViewController")
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension DeviceMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        longitude = location.longitude
        latitude = location.latitude
        
        if Home.current == nil {
            if flag {
                return
            }
            flag = true 
            homeManager.addHome(withName: "MyRoom", geoName: "Shenzhen", rooms: [""], latitude: latitude, longitude: longitude) { [weak self] _ in
                self?.homeManager.getHomeList { (homeModels) in
                    if homeModels?.count ?? 0 > 0  {
                        Home.current = homeModels?.first
                    }
                } failure: { (error) in
                
                }
            } failure: { (error) in
            }
        }
    }
}
