//
//  DeviceListTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceKit
import SVProgressHUD

class DeviceListTableViewController: UITableViewController {
    // MARK: - Property
    var home: TuyaSmartHome?
    private let homeManager = TuyaSmartHomeManager()
    var currentDeviceRow = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 110)
        //tableView.contentInsetAdjustmentBehavior = .never
        edgesForExtendedLayout = .all
        loadData()
        if Home.current == nil {
            homeManager.getHomeList { [weak self] (homeModels) in
                if homeModels?.count ?? 0 > 0  {
                    Home.current = homeModels?.first
                    self?.home = TuyaSmartHome(homeId: Home.current!.homeId)
                    self?.home?.delegate = self
                    self?.updateHomeDetail()
                }
            } failure: { (error) in
            
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("DeviceListTableViewController"), object: nil)
    }
    
    public func loadData() {
        if Home.current != nil {
            home = TuyaSmartHome(homeId: Home.current!.homeId)
            home?.delegate = self
            updateHomeDetail()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleNotification(_ notifiation: Notification) {
        tableView.reloadData()
    }
    
    @IBAction func pushToLocation(_ sender: Any) {
        let label = sender as? UITapGestureRecognizer
        let tag = label?.view?.tag ?? 0
        guard let deviceModel = home?.deviceList[tag] else { return }
        let sb = UIStoryboard(name: "DualMode", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DeviceLocationViewController") as! DeviceLocationViewController
        vc.deviceModel = deviceModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushToSettings(_ sender: Any) {
        let imageView = sender as? UITapGestureRecognizer
        let tag = imageView?.view?.tag ?? 0
        handleMore(tag: tag)
    }
    
    private func addDeleteDevice(_ cell: DeviceTableViewCell) {
        let rec = UILongPressGestureRecognizer(target: self, action: #selector(handleDeleteDevice(_:)))
        cell.addGestureRecognizer(rec)
    }
    
    @objc func handleDeleteDevice(_ sender: Any) {
        let rec = sender as? UILongPressGestureRecognizer
        let tag = rec?.view?.tag ?? 0
        let alertViewController = UIAlertController(title: "Delete Device", message: NSLocalizedString("Are you sure you want to remove the device?", comment: ""), preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            guard let deviceID = self.home?.deviceList[tag].devId else { return }
            guard let device = TuyaSmartDevice(deviceId: deviceID) else { return }
            device.remove {
                
            } failure: { error in
                
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        alertViewController.addAction(logoutAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = home?.deviceList.count ?? 0
        view.isHidden = count == 0
        if count > 0 {
            (self.parent as? DeviceMainViewController)?.showRightNavigationButton()
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "device-list-cell") as! DeviceTableViewCell
        cell.tag = indexPath.row
        cell.deviceImageView.tag = indexPath.row
        cell.locationLabel.tag = indexPath.row
        addDeleteDevice(cell)
        guard let deviceModel = home?.deviceList[indexPath.row] else { return cell }
        cell.delegate = self
        var value = 0
        var work = 0
        let cache = UserDefaults.standard.dictionary(forKey: "Scent") as? [String: Int] ?? [:]
        let locatios = UserDefaults.standard.dictionary(forKey: "location") as? [String: Int] ?? [:]
        value = cache[deviceModel.devId] ?? 0
        let dps = deviceModel.dps
        if value == 0 {
            value = Int(dps?["7"] as? String ?? "") ?? 0
        }
        work = Int(dps?["2"] as? String ?? "") ?? 0
        if value >= 128 {
            cell.scentLabel.isHidden = false
            cell.scentImageView.isHidden = false
            cell.addScentButton.isHidden = true
            cell.controlButton.isHidden = false
        } else {
            cell.scentLabel.isHidden = true
            cell.scentImageView.isHidden = true
            cell.addScentButton.isHidden = false
            cell.controlButton.isHidden = true
        }
        let scent = ((value >> 2) & 0b00011111) + 100
        cell.scentLabel.text = scentName["\(scent)"]
        //cell.scentImageView.image = UIImage(named: "f\(scent)")
        //let name = deviceModel.name
        let state = deviceModel.isOnline ? NSLocalizedString("Online", comment: "") : NSLocalizedString("Offline", comment: "")
        cell.stateLabel.text = state
        cell.stateLabel.textColor = deviceModel.isOnline ? UIColor.green : UIColor.red
        
        let location = locatios[deviceModel.devId] ?? 0
        cell.locationLabel.text = locations[min(locations.count - 1, location)]
        if work == 2 {
            cell.controlButton.isSelected = true
            cell.controlButton.backgroundColor = UIColor.hex(color: "F94C4C")
        } else {
            cell.controlButton.isSelected = false
            cell.controlButton.backgroundColor = UIColor.hex(color: "BB9BC5")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deviceID = home?.deviceList[indexPath.row].devId else { return }
        guard let device = TuyaSmartDevice(deviceId: deviceID) else { return }
        device.remove {
            
        } failure: { error in
            
        }

    }

    // MARK: - Private method
    private func updateHomeDetail() {
        home?.getDetailWithSuccess({ (model) in
            self.tableView.reloadData()
        }, failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: " ", message: errorMessage)
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

extension DeviceListTableViewController: DeviceTableViewCellDelegate {
    func handleMore(tag: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? DeviceTableViewCell else { return }
        if cell.scentLabel.isHidden {
            Alert.showBasicAlert(on: self, with: NSLocalizedString("First, Add your Scent!", comment: ""), message: "", actions: [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { [weak self] action in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
                vc?.type = 1
                self?.navigationController?.pushViewController(vc!, animated: true)
            })])
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "TuneSettingsViewController") as? TuneSettingsViewController
        guard let deviceID = home?.deviceList[tag].devId else { return }
        guard let device = TuyaSmartDevice(deviceId: deviceID) else { return }
        vc?.device = device
        navigationController?.pushViewController(vc!, animated: true)
        currentDeviceRow = tag
    }
    
    func handleFunction(button: UIButton, tag: Int) {
        guard let deviceModel = home?.deviceList[tag] else { return }
        if deviceModel.isOnline {
            guard let deviceID = deviceModel.devId else { return }
            guard let device = TuyaSmartDevice(deviceId: deviceID) else { return }
            publishMessage(with: ["2": button.isSelected ? "1" : "2"], device: device)
            button.isSelected = !button.isSelected
            if button.isSelected {
                button.backgroundColor = UIColor.hex(color: "F94C4C")
            } else {
                button.backgroundColor = UIColor.hex(color: "BB9BC5")
            }
        }
    }
    
    private func publishMessage(with dps: NSDictionary, device: TuyaSmartDevice) {
        guard let dps = dps as? [AnyHashable : Any] else { return }
        device.publishDps(dps, success: {
        }, failure: { (error) in
        })
    }
    
    func addScent(tag: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
        vc?.type = 1
        navigationController?.pushViewController(vc!, animated: true)
        currentDeviceRow = tag
    }
}
