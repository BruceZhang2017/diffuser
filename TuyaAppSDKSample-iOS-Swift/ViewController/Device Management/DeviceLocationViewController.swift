//
//  DeviceLocationViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBLEKit

let times = ["Pacific Standard Time", "Central Standard Time", "Mountain Standard Time", "Eastern Standard Time"]

class DeviceLocationViewController: BaseViewController {
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var timeZoneValueLabel: UILabel!
    
    public var deviceModel: TuyaSmartDeviceModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UserDefaults.standard.object(forKey: "location") as? [String : Int]
        let location = value?[deviceModel?.devId ?? ""] ?? 0
        locationValueLabel.text = locations[location]
        
        let time = UserDefaults.standard.object(forKey: "time") as? [String : Int]
        let t = time?[deviceModel?.devId ?? ""] ?? 0
        timeZoneValueLabel.text = times[t]
    }
    

    @IBAction func changeLocation(_ sender: Any) {
        var array : [UIAlertAction] = []
        array.append(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        for (index, item) in locations.enumerated() {
            array.append(UIAlertAction(title: item, style: .default, handler: { [weak self] action in
                self?.locationValueLabel.text = item
                UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": index], forKey: "location")
                UserDefaults.standard.synchronize()
            }))
        }
        Alert.showBasicAction(on: self,
                              with: "Diffuser Location",
                              message: "",
                              actions: array
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
                                UIAlertAction(title: times[0], style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = times[0]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 0], forKey: "time")
                                    UserDefaults.standard.synchronize()
                                }),
                                UIAlertAction(title: times[1], style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = times[1]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 1], forKey: "time")
                                    UserDefaults.standard.synchronize()
                                }),
                                UIAlertAction(title: times[2], style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = times[2]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 2], forKey: "time")
                                    UserDefaults.standard.synchronize()
                                }),
                                UIAlertAction(title: times[3], style: .default, handler: { [weak self] action in
                                    self?.timeZoneValueLabel.text = times[3]
                                    UserDefaults.standard.setValue([self?.deviceModel?.devId ?? "": 3], forKey: "time")
                                    UserDefaults.standard.synchronize()
                                })]
        )
        log.info("[配网] 修改time zone")
    }

    @IBAction func continueWithConfi(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("DeviceListTableViewController"), object: nil)
        navigationController?.popViewController(animated: true)
    }
}
