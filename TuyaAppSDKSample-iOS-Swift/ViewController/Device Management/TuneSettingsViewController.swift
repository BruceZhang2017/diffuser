//
//  TuneSettingsViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceCoreKit
import Toaster
import McPicker
import SVProgressHUD

var weekdays = [["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"]]

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
    @IBOutlet weak var start2Label: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var end2Label: UILabel!
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var width1LC: NSLayoutConstraint!
    @IBOutlet weak var width2LC: NSLayoutConstraint!
    @IBOutlet weak var width3LC: NSLayoutConstraint!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    @IBOutlet weak var SprayView: UIView!
    @IBOutlet weak var sprayLabel: UILabel!
    @IBOutlet weak var sprayValueLabel: UILabel!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var stopValueLabel: UILabel!
    var device: TuyaSmartDevice?
    var schedualIndex = 1 // 当前标志的位置
    var v = -1
    var spray = 0
    var stop = 0
    var current = 0 // 当前星期几的位置
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleScent(_:)), name: Notification.Name("TuneSettings"), object: nil)
        refreshScent()
        if let name = device?.deviceModel.name {
            let array = name.split(separator: "-")
            deviceNameLabel.text = String(array[0])
        }
        //deviceNameLabel.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(modifyName))
//        tap.numberOfTapsRequired = 1
//        deviceNameLabel.addGestureRecognizer(tap)
        
        for button in dayButtons {
            button.setTitleColor(UIColor.hex(color: "BB9BC5"), for: .selected)
        }
        SVProgressHUD.show()
        publishMessage(with: ["8" : "8A"])
        width1LC.constant = (screenWidth - 24) / 2
        width2LC.constant = (screenWidth - 24) / 2
        width3LC.constant = (screenWidth - 24) / 2
        tabHeight.constant = UIDevice.isSameToIphoneX() ? 83 : 50
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshButtons()
        refreshSchedual()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    @objc private func modifyName() {
//        let alertController = UIAlertController(title: "修改设备名称", message: nil, preferredStyle: .alert)
//        alertController.addTextField(configurationHandler: { [weak self] (textField: UITextField!) -> Void in
//            textField.placeholder = "请输入"
//            textField.text = self?.deviceNameLabel.text
//        })
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let okAction = UIAlertAction(title: "确认", style: .default , handler: { [weak self] (action: UIAlertAction!) -> Void in
//            let login = (alertController.textFields?.first)! as UITextField
//            let str = login.text ?? "no name"
//            self?.deviceNameLabel.text = str
//            self?.device?.updateName(str, success: {
//
//            }, failure: { error in
//
//            })
//
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//
//    }
    
    private func refreshButtons() {
        for i in 0..<7 {
            dayButtons[i].isSelected = i == current
        }
    }
    
    private func refreshSchedual() {
        let day = weekdays[current]
        let startTime = day[0].split(separator: "-")[0]
        let endTime = day[0].split(separator: "-")[1]
        let start2Time = day[1].split(separator: "-")[0]
        let end2Time = day[1].split(separator: "-")[1]
        if startTime.count > 0 && endTime.count > 0 {
            var value = startTime.split(separator: ":")
            var hour = Int(value[0]) ?? 0
            if hour >= 12 {
                startLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                startLabel.text = "\(startTime) AM"
            }
            
            value = endTime.split(separator: ":")
            hour = Int(value[0]) ?? 0
            if hour >= 12 {
                endLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                endLabel.text = "\(endTime) AM"
            }
        } else {
            startLabel.text = "00:00 AM"
            endLabel.text = "00:00 AM"
        }
        if start2Time.count > 0 && end2Time.count > 0 {
            var value = start2Time.split(separator: ":")
            var hour = Int(value[0]) ?? 0
            if hour >= 12 {
                start2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                start2Label.text = "\(start2Time) AM"
            }
            
            value = end2Time.split(separator: ":")
            hour = Int(value[0]) ?? 0
            if hour >= 12 {
                end2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
            } else {
                end2Label.text = "\(end2Time) AM"
            }
        } else {
            start2Label.text = "00:00 AM"
            end2Label.text = "00:00 AM"
        }
    }
    
    // 20210616 修改为Edit Schedual功能。
    @IBAction private func deleteSchedual(_ sender: Any) {
//        if !(device?.deviceModel.isOnline ?? false) {
//            Toast(text: "设备不在线").show()
//            return
//        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddSchedualViewController") as? AddSchedualViewController
        vc?.currenday = current
        vc?.device = device
        navigationController?.pushViewController(vc!, animated: true)
        
//        if scheduals.count == 0 {
//            Toast(text: "you don't have a schedual").show()
//            return
//        }
//        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this schedule?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        let delete = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
//            var value = "8A"
//            var d = 0
//            for (i, day) in days.enumerated() {
//                d += (day << i)
//            }
//            let st = NSString(format:"%2X", d) as String
//            print("天数：\(d) \(st)")
//            value += st
//            value += "0c060624"
//            for (i, schedual) in scheduals.enumerated() {
//                if i == scheduals.count - 1 {
//                    break
//                }
//                value += schedual.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "-", with: "")
//            }
//            if scheduals.count - 1 < 5 {
//                let count = 5 - scheduals.count + 1
//                for _ in 0..<count {
//                    value += "00000000"
//                }
//            }
//            self?.publishMessage(with: ["8" : value])
//            scheduals.removeLast()
//            self?.refreshSchedual()
//        })
//        alert.addAction(delete)
//        present(alert, animated: true, completion: nil)
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
            generalLabel.text = "GENERAL SETTINGS"
        } else if schedualIndex == 2 {
            images = ["Stubiao", "baseline_date_range_white", "Vector3"]
            schedualView.isHidden = false
            settingsView.isHidden = true
            refreshView.isHidden = true
            generalLabel.text = "SCHEDULE"
        } else {
            images = ["Vector3", "Stubiao", "baseline_date_range_white"]
            schedualView.isHidden = true
            settingsView.isHidden = true
            refreshView.isHidden = false
            generalLabel.text = "CURRENT FRAGRANCE"
        }
        for (i, button) in buttons.enumerated() {
            button.setImage(UIImage(named: images[i]), for: .normal)
        }
    }
    
//    @IBAction func addNewSchedual(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "AddSchedualViewController") as? AddSchedualViewController
//        vc?.device = device
//        navigationController?.pushViewController(vc!, animated: true)
//    }
    
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
        let titles = ["Low", "Medium", "High"]
        let tag = (sender as! UIButton).tag
        let value = intensityValueLabel.text ?? ""
        for (i, title) in titles.enumerated() {
            if title == value {
                v = i
                break
            }
        }
        if tag == 1 { // 减少
            if v <= 0 {
                return
            }
            v -= 1
            intensityValueLabel.text = titles[v]
        } else { // 增加
            if v >= 2 {
                return
            }
            v += 1
            intensityValueLabel.text = titles[v]
        }
    }
    
    private func refreshIntensity() {
        let titles = ["Low", "Medium", "High"]
        intensityValueLabel.text = titles[v]
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
            value = Int(dps?["7"] as? String ?? "") ?? 0
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
                self?.i += 1
                let d = (self?.i ?? 0) > 2 ? 0.9 : 2
                self?.perform(#selector(TuneSettingsViewController.handle8CMD), with: nil, afterDelay: d)
            }
        }, failure: { (error) in
            let errorMessage = error?.localizedDescription ?? ""
            SVProgressHUD.showError(withStatus: errorMessage)
        })
    }
    
    private func refreshSpray() {
        if spray > 0 {
            sprayValueLabel.text = "\(spray * 5)秒"
        }
    }
    
    private func refreshStop() {
        if stop > 0 {
            stopValueLabel.text = "\(stop * 5)秒"
        }
    }
    
    /// 8M 7f 0c 06 06 24 00002359 00000000 00000000 00000000 00000000
    @objc private func handle8CMD() {
        guard let dps = device?.deviceModel.dps else {
            print("数据为空")
            return
        }
        guard let value = dps["8"] as? String else {
            print("数据为空不是8")
            return
        }
        if value.hasPrefix("9M") && value.count > 3 {
            let start = value.index(value.startIndex, offsetBy: 2)
            let end = value.index(value.startIndex, offsetBy: 3)
            let hexi:UInt = UInt(String(value[start...end]), radix: 16) ?? 0
            v = Int(hexi)
            refreshIntensity()
            if i > 2 {
                return
            }
            publishMessage(with: ["8" : "6A00"])
        }
        if value.hasPrefix("8M") && value.count > 12 {
            var start = value.index(value.startIndex, offsetBy: 2)
            var end = value.index(value.startIndex, offsetBy: 3)
            var hexi:UInt = UInt(String(value[start...end]), radix: 16) ?? 0
            
            start = value.index(value.startIndex, offsetBy: 4)
            end = value.index(value.startIndex, offsetBy: 5)
            hexi = UInt(String(value[start...end]), radix: 16) ?? 0
            spray = Int(hexi)
            refreshSpray()
            
            start = value.index(value.startIndex, offsetBy: 10)
            end = value.index(value.startIndex, offsetBy: 11)
            hexi = UInt(String(value[start...end]), radix: 16) ?? 0
            stop = Int(hexi)
            refreshStop()
            publishMessage(with: ["8" : "9A"])
        }
        if value.hasPrefix("6M") && value.count >= 14 {
            if value.hasPrefix("6M00") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[0][0] = hexi
                publishMessage(with: ["8" : "6A01"])
            }
            if value.hasPrefix("6M01") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[0][1] = hexi
                publishMessage(with: ["8" : "6A02"])
            }
            if value.hasPrefix("6M02") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[1][0] = hexi
                publishMessage(with: ["8" : "6A03"])
            }
            if value.hasPrefix("6M03") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[1][1] = hexi
                publishMessage(with: ["8" : "6A04"])
            }
            if value.hasPrefix("6M04") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[2][0] = hexi
                publishMessage(with: ["8" : "6A05"])
            }
            if value.hasPrefix("6M05") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[2][1] = hexi
                publishMessage(with: ["8" : "6A06"])
            }
            if value.hasPrefix("6M06") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[3][0] = hexi
                publishMessage(with: ["8" : "6A07"])
            }
            if value.hasPrefix("6M07") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[3][1] = hexi
                publishMessage(with: ["8" : "6A08"])
            }
            if value.hasPrefix("6M08") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[4][0] = hexi
                publishMessage(with: ["8" : "6A09"])
            }
            if value.hasPrefix("6M09") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[4][1] = hexi
                publishMessage(with: ["8" : "6A0a"])
            }
            if value.hasPrefix("6M0a") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[5][0] = hexi
                publishMessage(with: ["8" : "6A0b"])
            }
            if value.hasPrefix("6M0b") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[5][1] = hexi
                publishMessage(with: ["8" : "6A0c"])
            }
            if value.hasPrefix("6M0c") {
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[6][0] = hexi
                publishMessage(with: ["8" : "6A0d"])
            }
            if value.hasPrefix("6M0d") {
                SVProgressHUD.dismiss()
                let start = value.index(value.startIndex, offsetBy: 6)
                let end = value.endIndex
                var hexi = String(value[start..<end])
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 6))
                hexi.insert("-", at: hexi.index(hexi.startIndex, offsetBy: 4))
                hexi.insert(":", at: hexi.index(hexi.startIndex, offsetBy: 2))
                weekdays[6][1] = hexi
                refreshSchedual()
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        publishMessage(with: ["8" : "9A0\(v)"])
    }
    
    @IBAction private func handleShowDeviceList(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("Main"), object: 0)
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    @IBAction private func handleShowSettings(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("Main"), object: 1)
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    @IBAction func setSprayValue(_ sender: Any) {
        McPicker.show(data: initializeTimeArray()) {  [weak self] (selections: [Int : String]) -> Void in
            if let value = selections[0] {
                self?.publishMessage(with: ["7" : (Int(value) ?? 0) / 5])
            }
        }

    }
    
    @IBAction func setStopValue(_ sender: Any) {
        McPicker.show(data: initializeTimeArray()) {  [weak self] (selections: [Int : String]) -> Void in
            if let value = selections[0] {
                self?.publishMessage(with: ["102" : (Int(value) ?? 0) / 5])
            }
        }
    }
    
    @IBAction func tapWeekDay(_ sender: Any) {
        let button = sender as! UIButton
        current = button.tag
        refreshButtons()
        refreshSchedual()
    }
    
}

extension TuneSettingsViewController {
    func initializeTimeArray() -> [[String]] {
        var array: [String] = []
        for i in 0..<60 {
            array.append("\((i + 1) * 50)")
        }
        return [array]
    }
}
