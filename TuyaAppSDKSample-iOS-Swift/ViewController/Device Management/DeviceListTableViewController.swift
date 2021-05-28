//
//  DeviceListTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceKit

class DeviceListTableViewController: UITableViewController {
    // MARK: - Property
    private var home: TuyaSmartHome?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 110)
        if Home.current != nil {
            home = TuyaSmartHome(homeId: Home.current!.homeId)
            home?.delegate = self
            updateHomeDetail()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = home?.deviceList.count ?? 0
        view.isHidden = count == 0
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "device-list-cell")!
        
        guard let deviceModel = home?.deviceList[indexPath.row] else { return cell }
        
        let name = deviceModel.name
        let state = deviceModel.isOnline ? NSLocalizedString("Online", comment: "") : NSLocalizedString("Offline", comment: "")
        print("当前设备的名称：\(name) 状态：\(state)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeviceControlTableViewController") as! DeviceControlTableViewController
        
        guard let deviceID = home?.deviceList[indexPath.row].devId else { return }
        guard let device = TuyaSmartDevice(deviceId: deviceID) else { return }
        vc.device = device
        
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Private method
    private func updateHomeDetail() {
        home?.getDetailWithSuccess({ (model) in
            self.tableView.reloadData()
        }, failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Fetch Home", comment: ""), message: errorMessage)
        })
    }

}

extension DeviceListTableViewController: TuyaSmartHomeDelegate{
    func homeDidUpdateInfo(_ home: TuyaSmartHome!) {
        tableView.reloadData()
    }
    
    func home(_ home: TuyaSmartHome!, didAddDeivice device: TuyaSmartDeviceModel!) {
        tableView.reloadData()
    }
    
    func home(_ home: TuyaSmartHome!, didRemoveDeivice devId: String!) {
        tableView.reloadData()
    }
    
    func home(_ home: TuyaSmartHome!, deviceInfoUpdate device: TuyaSmartDeviceModel!) {
        tableView.reloadData()
    }
    
    func home(_ home: TuyaSmartHome!, device: TuyaSmartDeviceModel!, dpsUpdate dps: [AnyHashable : Any]!) {
        tableView.reloadData()
    }
}
