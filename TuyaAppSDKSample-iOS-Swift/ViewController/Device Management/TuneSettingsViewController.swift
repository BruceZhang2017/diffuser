//
//  TuneSettingsViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceCoreKit
import Toaster

var days = [0, 0, 0, 0, 0, 0, 0]
var scheduals: [String] = []

class TuneSettingsViewController: BaseViewController {
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var schedualView: UIView!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var dayButtons: [UIButton]!
    @IBOutlet weak var scentImageView: UIImageView!
    @IBOutlet weak var scentNameLabel: UILabel!
    @IBOutlet weak var intensityValueLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    var device: TuyaSmartDevice?
    var schedualIndex = 1 // 当前标志的位置
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleScent(_:)), name: Notification.Name("TuneSettings"), object: nil)
        refreshScent()
        deviceNameLabel.text = device?.deviceModel.name
        deviceNameLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(modifyName))
        tap.numberOfTapsRequired = 1
        deviceNameLabel.addGestureRecognizer(tap)
        
        refreshIntensity()
        for button in dayButtons {
            button.setTitleColor(UIColor.hex(color: "32D62F"), for: .selected)
        }
        publishMessage(with: ["8" : "8A"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if scheduals.count > 0 {
            refreshButtons()
            refreshSchedual()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func modifyName() {
        let alertController = UIAlertController(title: "修改设备名称", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { [weak self] (textField: UITextField!) -> Void in
            textField.placeholder = "请输入"
            textField.text = self?.deviceNameLabel.text
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default , handler: { [weak self] (action: UIAlertAction!) -> Void in
            let login = (alertController.textFields?.first)! as UITextField
            let str = login.text ?? "no name"
            self?.deviceNameLabel.text = str
            self?.device?.updateName(str, success: {
                
            }, failure: { error in
                
            })
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func refreshButtons() {
        for (i, value) in days.enumerated() {
            dayButtons[i].isSelected = value > 0
        }
    }
    
    private func refreshSchedual() {
        if scheduals.count > 0 {
            guard let item = scheduals.last else {
                return
            }
            let array = item.split(separator: "-").map({String($0)})
            if array.count != 2 {
                return
            }
            var value = array[0].split(separator: ":")
            var hour = Int(value[0]) ?? 0
            if hour >= 12 {
                startLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                startLabel.text = "\(array[0]) AM"
            }
            
            value = array[1].split(separator: ":")
            hour = Int(value[0]) ?? 0
            if hour >= 12 {
                endLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                endLabel.text = "\(array[1]) AM"
            }
        } else {
            startLabel.text = "00:00 AM"
            endLabel.text = "00:00 AM"
        }
    }
    
    @IBAction private func deleteSchedual(_ sender: Any) {
        if !(device?.deviceModel.isOnline ?? false) {
            Toast(text: "设备不在线").show()
            return
        }
        if scheduals.count == 0 {
            Toast(text: "you don't have a schedual").show()
            return
        }
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this schedule?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            var value = "8A"
            var d = 0
            for (i, day) in days.enumerated() {
                d += (day << i)
            }
            let st = NSString(format:"%2X", d) as String
            print("天数：\(d) \(st)")
            value += st
            value += "0c060624"
            for (i, schedual) in scheduals.enumerated() {
                if i == scheduals.count - 1 {
                    break
                }
                value += schedual.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "-", with: "")
            }
            if scheduals.count - 1 < 5 {
                let count = 5 - scheduals.count + 1
                for _ in 0..<count {
                    value += "00000000"
                }
            }
            self?.publishMessage(with: ["8" : value])
            scheduals.removeLast()
            self?.refreshSchedual()
        })
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func handleShow(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        if tag == 2 {
            return
        }
        if tag == 1 {
            if schedualIndex == 1 {
                schedualIndex = 2
            } else if schedualIndex == 2 {
                schedualIndex = 3
            } else {
                schedualIndex = 1
            }
        }
        if tag == 3 {
            if schedualIndex == 1 {
                schedualIndex = 3
            } else if schedualIndex == 2 {
                schedualIndex = 1
            } else {
                schedualIndex = 2
            }
        }
        var images: [String] = []
        if schedualIndex == 1 {
            images = ["baseline_date_range_white", "Vector3", "Stubiao"]
            schedualView.isHidden = true
            settingsView.isHidden = false
            refreshView.isHidden = true
        } else if schedualIndex == 2 {
            images = ["Stubiao", "baseline_date_range_white", "Vector3"]
            schedualView.isHidden = false
            settingsView.isHidden = true
            refreshView.isHidden = true
        } else {
            images = ["Vector3", "Stubiao", "baseline_date_range_white"]
            schedualView.isHidden = true
            settingsView.isHidden = true
            refreshView.isHidden = false
        }
        for (i, button) in buttons.enumerated() {
            button.setImage(UIImage(named: images[i]), for: .normal)
        }
    }
    
    @IBAction func addNewSchedual(_ sender: Any) {
        if scheduals.count >= 5 {
            Toast(text: "schedual数量最多可添加5个").show()
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddSchedualViewController") as? AddSchedualViewController
        vc?.device = device
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc public func handleScent(_ notification: Notification) {
        let obj = notification.object as? Int ?? 0
        let scent = obj + 100
        scentNameLabel.text = scentName["\(scent)"]
        scentImageView.image = UIImage(named: "f\(scent)")
    }
    
    @IBAction func changeScent(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController
        vc?.type = 1
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func changeIntensity(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        let value = intensityValueLabel.text ?? "1"
        let v = Int(value) ?? 1
        if tag == 1 {
            if v <= 1 {
                return
            }
            intensityValueLabel.text = "1"
        } else {
            if v >= 2 {
                return
            }
            intensityValueLabel.text = "2"
        }
        let value2 = intensityValueLabel.text ?? "1"
        publishMessage(with: ["101" : value2])
    }
    
    private func refreshIntensity() {
        guard let device = device else { return }
        let dps = device.deviceModel.dps
        intensityValueLabel.text = dps?["101"] as? String
    }
    
    private func refreshScent() {
        guard let dev = device else {
            return
        }
        let dps = dev.deviceModel.dps
        var value = 0
        let cache = UserDefaults.standard.dictionary(forKey: "Scent") as? [String: Int] ?? [:]
        value = cache[dev.deviceModel.devId] ?? 0
        if value == 0 {
            value = dps?["7"] as? Int ?? 0
        }
        let scent = ((value >> 2) & 0b00011111) + 100
        scentNameLabel.text = scentName["\(scent)"]
        scentImageView.image = UIImage(named: "f\(scent)")
    }
    
    private func publishMessage(with dps: NSDictionary) {
        guard let dps = dps as? [AnyHashable : Any] else { return }

        device?.publishDps(dps, success: {
            [weak self] in
            if let _ = dps["8"] {
                self?.perform(#selector(TuneSettingsViewController.handle8CMD), with: nil, afterDelay: 2)
            }
        }, failure: { (error) in
            let errorMessage = error?.localizedDescription ?? ""
            SVProgressHUD.showError(withStatus: errorMessage)
        })
    }
    
    /// 8M 7f 0c 06 06 24 00002359 00000000 00000000 00000000 00000000
    @objc private func handle8CMD() {
        guard let dps = device?.deviceModel.dps else {
            return
        }
        guard let value = dps["8"] as? String else {
            return
        }
        if value.count != 52 {
            return
        }
        if !value.hasPrefix("8M") {
            return
        }
        let start = value.index(value.startIndex, offsetBy: 2)
        let end = value.index(value.startIndex, offsetBy: 3)
        let hexi:UInt = UInt(String(value[start...end]), radix: 16) ?? 0
        for i in 0..<7 {
            let v = hexi >> i
            let v2 = v & 1
            days[i] = Int(v2)
        }
        refreshButtons()
        scheduals.removeAll()
        for i in 0..<5 {
            let start = value.index(value.startIndex, offsetBy: 12 + 8 * i)
            let end = value.index(value.startIndex, offsetBy: 20 + 8 * i)
            var v = String(value[start..<end])
            if v == "00000000" {
                continue
            }
            v.insert(":", at: v.index(v.startIndex, offsetBy: 2))
            v.insert(":", at: v.index(v.endIndex, offsetBy: -2))
            v.insert("-", at: v.index(v.startIndex, offsetBy: 5))
            scheduals.append(v)
        }
        refreshSchedual()
    }
}
