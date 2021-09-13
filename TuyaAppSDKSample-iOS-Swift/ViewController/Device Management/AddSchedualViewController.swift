//
//  AddSchedualViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceCoreKit
import Toaster
import SVProgressHUD

class AddSchedualViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var sView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var start2Label: UILabel!
    @IBOutlet weak var end2Label: UILabel!
    @IBOutlet weak var e1Label: UILabel!
    @IBOutlet weak var s1Label: UILabel!
    @IBOutlet weak var s2Label: UILabel!
    @IBOutlet weak var e2Label: UILabel!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var schedule2Label: UILabel!
    @IBOutlet weak var ivLineLeadingLC: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var s1TopLC: NSLayoutConstraint!
    @IBOutlet weak var e1TopLC: NSLayoutConstraint!
    @IBOutlet weak var schedule2TopLC: NSLayoutConstraint!
    @IBOutlet weak var s2TopLC: NSLayoutConstraint!
    @IBOutlet weak var e2TopLC: NSLayoutConstraint!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    var picker: ShuKeTimerPickerView?
    var device: TuyaSmartDevice?
    var currenday = 0
    var wDays: [[String]] = []
    var activi: [[Bool]] = []
    var i = 0 // 发送指令的，当前是第几个
    private let weekTitles = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wDays = weekdays
        activi = activates
        
        for button in buttons {
            button.setTitleColor(UIColor.hex(color: "BB9BC5"), for: .selected)
        }
        
        refreshUI()
        
        let label = UILabel()
        label.textColor = UIColor.hex(color: "BB9BC5")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Schedule"
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        label.textAlignment = .center
        navigationItem.titleView = label
        
        datePicker.datePickerMode = .time
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        
        switch1.tintColor = .lightGray
        switch1.backgroundColor = .lightGray
        switch1.onTintColor = UIColor.hex(color: "BB9BC5")
        switch2.tintColor = .lightGray
        switch2.backgroundColor = .lightGray
        switch2.onTintColor = UIColor.hex(color: "BB9BC5")
        
        switch1.layer.cornerRadius = switch1.bounds.height/2.0
        switch1.layer.masksToBounds = true
        switch2.layer.cornerRadius = switch2.bounds.height/2.0
        switch2.layer.masksToBounds = true
        
        tabHeight.constant = UIDevice.isSameToIphoneX() ? 83 : 50
    }
    
    private func refreshUI() {
        for (i, item) in activi.enumerated() {
            buttons[i].isSelected = item[0] || item[1]
            if i == currenday {
                buttons[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            } else {
                buttons[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
        sundayLabel.text = weekTitles[currenday]
        ivLineLeadingLC.constant = CGFloat(currenday * (44 + 5))
        let startTime = String(wDays[currenday][0].split(separator: "-")[0])
        let endTime = String(wDays[currenday][0].split(separator: "-")[1])
        let  start2Time = String(wDays[currenday][1].split(separator: "-")[0])
        let  end2Time = String(wDays[currenday][1].split(separator: "-")[1])
        if startTime.count > 0 {
            var value = startTime.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    startLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    startLabel.text = "\(startTime) AM"
                }
            }
            
            value = endTime.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    endLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    endLabel.text = "\(endTime) AM"
                }
            }
        }
        
        if start2Time.count > 0 {
            var value = start2Time.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    start2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    start2Label.text = "\(start2Time) AM"
                }
            }
            
            value = end2Time.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    end2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    end2Label.text = "\(end2Time) AM"
                }
            }
        }
        
        switch1.isOn = activi[currenday][0]
        switch2.isOn = activi[currenday][1]
        showSchedual1(value: activi[currenday][0])
        showSchedual2(value: activi[currenday][1])
        datePicker.isHidden = true
    }
    
    private func showSchedual1(value: Bool) {
        startLabel.isHidden = !value
        s1Label.isHidden = !value
        endLabel.isHidden = !value
        e1Label.isHidden = !value
        btn1.isHidden = !value
        btn2.isHidden = !value
    }
    
    private func showSchedual2(value: Bool) {
        start2Label.isHidden = !value
        s2Label.isHidden = !value
        end2Label.isHidden = !value
        e2Label.isHidden = !value
        btn3.isHidden = !value
        btn4.isHidden = !value
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let s = sender as? UISwitch
        let tag = s?.tag ?? 0
        if tag == 1 {
            showSchedual1(value: switch1.isOn)
            datePicker?.isHidden = true
            activi[currenday][0] = switch1.isOn
        } else {
            showSchedual2(value: switch2.isOn)
            datePicker?.isHidden = true
            activi[currenday][1] = switch2.isOn
        }
        for (i, item) in activi.enumerated() {
            buttons[i].isSelected = item[0] || item[1]
            if i == currenday {
                buttons[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            } else {
                buttons[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
    }
    
    @IBAction func selectDay(_ sender: Any) {
        let button = sender as! UIButton
        currenday = button.tag
        refreshUI()
    }
    
    @IBAction func confirm(_ sender: Any) {
        SVProgressHUD.show()
        var s = wDays[0][0]
        s = s.replacingOccurrences(of: ":", with: "")
        s = s.replacingOccurrences(of: "-", with: "")
        publishMessage(with: ["8" : "6A00\(activi[0][0] ? "01" : "00")\(s)"])
    }
    
    private func showAlert() {
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.type = 2
        present(vc, animated: true) {
            
        }
    }
    
    private func publishMessage(with dps: NSDictionary) {
        guard let dps = dps as? [AnyHashable : Any] else { return }

        device?.publishDps(dps, success: {
            [weak self] in
            self?.i += 1
            self?.handle8CMD()
        }, failure: { (error) in
            let errorMessage = error?.localizedDescription ?? ""
            SVProgressHUD.showError(withStatus: errorMessage)
        })
    }
    
    @objc private func handle8CMD() {
        if i == 1 {
            var s = wDays[0][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A01\(activi[0][1] ? "01" : "00")\(s)"])
        }
        if i == 2 {
            var s = wDays[1][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A02\(activi[1][0] ? "02" : "00")\(s)"])
        }
        if i == 3 {
            var s = wDays[1][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A03\(activi[1][1] ? "02" : "00")\(s)"])
        }
        if i == 4 {
            var s = wDays[2][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A04\(activi[2][0] ? "04" : "00")\(s)"])
        }
        if i == 5 {
            var s = wDays[2][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A05\(activi[2][1] ? "04" : "00")\(s)"])
        }
        if i == 6 {
            var s = wDays[3][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A06\(activi[3][0] ? "08" : "00")\(s)"])
        }
        if i == 7 {
            var s = wDays[3][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A07\(activi[3][1] ? "08" : "00")\(s)"])
        }
        if i == 8 {
            var s = wDays[4][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A08\(activi[4][0] ? "10" : "00")\(s)"])
        }
        if i == 9 {
            var s = wDays[4][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A09\(activi[4][1] ? "10" : "00")\(s)"])
        }
        if i == 10 {
            var s = wDays[5][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0a\(activi[5][0] ? "20" : "00")\(s)"])
        }
        if i == 11 {
            var s = wDays[5][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0b\(activi[5][1] ? "20" : "00")\(s)"])
        }
        if i == 12 {
            var s = wDays[6][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0c\(activi[6][0] ? "40" : "00")\(s)"])
        }
        if i == 13 {
            var s = wDays[6][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0d\(activi[6][1] ? "40" : "00")\(s)"])
        }
        if i == 14 {
            SVProgressHUD.dismiss()
            weekdays = wDays
            activates = activi
            showAlert()
            i = 0
        }
    }
    
    @IBAction func deleteSchedule(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Are you sure you want to delete this schedule?", message: nil, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            self.wDays = [["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"], ["00:00-00:00","00:00-00:00"]]
            self.activi = [[false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false]]
            self.refreshUI()
            SVProgressHUD.show()
            var s = self.wDays[0][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            self.publishMessage(with: ["8" : "6A00\(self.activi[0][0] ? "01" : "00")\(s)"])
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel)
        
        alertViewController.addAction(logoutAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func showPicker(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        datePicker.isHidden = !btn.isSelected
        sViewHeightLC.constant = btn.isSelected ? 350 : 250
        let tag = btn.tag
        if tag == 1 {
            btn2.isSelected = false
            btn3.isSelected = false
            btn4.isSelected = false
            startLabel.isHidden = btn.isSelected
            endLabel.isHidden = false
            start2Label.isHidden = !activi[currenday][1]
            end2Label.isHidden = !activi[currenday][1]
            datePicker.snp.remakeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(100)
                make.centerY.equalTo(btn1)
                make.right.equalTo(btn1.snp.left)
            }
            datePicker.tag = 1
            s1TopLC.constant = btn.isSelected ? 70 : 20
            e1TopLC.constant = btn.isSelected ? 70 : 20
            schedule2TopLC.constant = 20
            s2TopLC.constant = 20
            e2TopLC.constant = 20
            let time = String(wDays[currenday][0].split(separator: "-")[0])
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            var date: Date
            if time.count > 0 {
                date = dateformatter.date(from: time) ?? Date()
            } else {
                date = Date()
            }
            datePicker.setDate(date, animated: false)
        } else if tag == 2 {
            btn1.isSelected = false
            btn3.isSelected = false
            btn4.isSelected = false
            startLabel.isHidden = false
            endLabel.isHidden = btn.isSelected
            start2Label.isHidden = !activi[currenday][1]
            end2Label.isHidden = !activi[currenday][1]
            datePicker.snp.remakeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(100)
                make.centerY.equalTo(btn2)
                make.right.equalTo(btn2.snp.left)
            }
            datePicker.tag = 2
            s1TopLC.constant = 20
            e1TopLC.constant = btn.isSelected ? 70 : 20
            schedule2TopLC.constant = btn.isSelected ? 70 : 20
            s2TopLC.constant = 20
            e2TopLC.constant = 20
            let time = String(wDays[currenday][0].split(separator: "-")[1])
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            var date: Date
            if time.count > 0 {
                date = dateformatter.date(from: time) ?? Date()
            } else {
                date = Date()
            }
            datePicker.setDate(date, animated: false)
        } else if tag == 3 {
            btn1.isSelected = false
            btn2.isSelected = false
            btn4.isSelected = false
            startLabel.isHidden = !activi[currenday][0]
            endLabel.isHidden = !activi[currenday][0]
            start2Label.isHidden = btn.isSelected
            end2Label.isHidden = false
            datePicker.snp.remakeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(100)
                make.centerY.equalTo(btn3)
                make.right.equalTo(btn3.snp.left)
            }
            datePicker.tag = 3
            s1TopLC.constant = 20
            e1TopLC.constant = 20
            schedule2TopLC.constant = 20
            s2TopLC.constant = btn.isSelected ? 70 : 20
            e2TopLC.constant = btn.isSelected ? 70 : 20
            let time = String(wDays[currenday][1].split(separator: "-")[0])
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            var date: Date
            if time.count > 0 {
                date = dateformatter.date(from: time) ?? Date()
            } else {
                date = Date()
            }
            datePicker.setDate(date, animated: false)
        } else if tag == 4 {
            btn1.isSelected = false
            btn2.isSelected = false
            btn3.isSelected = false
            startLabel.isHidden = !activi[currenday][0]
            endLabel.isHidden = !activi[currenday][0]
            start2Label.isHidden = false
            end2Label.isHidden = btn.isSelected
            for constraint in datePicker.constraints {
                datePicker.removeConstraint(constraint)
            }
            datePicker.snp.remakeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(100)
                make.centerY.equalTo(btn4)
                make.right.equalTo(btn4.snp.left)
            }
            datePicker.tag = 4
            s1TopLC.constant = 20
            e1TopLC.constant = 20
            schedule2TopLC.constant = 20
            s2TopLC.constant = 20
            e2TopLC.constant = btn.isSelected ? 70 : 20
            let time = String(wDays[currenday][1].split(separator: "-")[1])
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            var date: Date
            if time.count > 0 {
                date = dateformatter.date(from: time) ?? Date()
            } else {
                date = Date()
            }
            datePicker.setDate(date, animated: false)
        }
        
    }
    
    @objc private func dateChange(_ sender: Any) {
        let datepicker = sender as! UIDatePicker
        let date = datepicker.date
        let tag = datepicker.tag
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let s = dateformatter.string(from: date)
        if tag == 1 {
            let str = wDays[currenday][0]
            var array = str.split(separator: "-").map{String($0)}
            array[0] = s
            wDays[currenday][0] = array.joined(separator: "-")
            if s.count > 0 {
                let value = s.split(separator: ":")
                if value.count == 2 {
                    let hour = Int(value[0]) ?? 0
                    if hour >= 12 {
                        startLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                    } else {
                        startLabel.text = "\(s) AM"
                    }
                }
            }
        } else if tag == 2 {
            let str = wDays[currenday][0]
            var array = str.split(separator: "-").map{String($0)}
            array[1] = s
            wDays[currenday][0] = array.joined(separator: "-")
            if s.count > 0 {
                let value = s.split(separator: ":")
                if value.count == 2 {
                    let hour = Int(value[0]) ?? 0
                    if hour >= 12 {
                        endLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                    } else {
                        endLabel.text = "\(s) AM"
                    }
                }
            }
        } else if tag == 3 {
            let str = wDays[currenday][1]
            var array = str.split(separator: "-").map{String($0)}
            array[0] = s
            wDays[currenday][1] = array.joined(separator: "-")
            if s.count > 0 {
                let value = s.split(separator: ":")
                if value.count == 2 {
                    let hour = Int(value[0]) ?? 0
                    if hour >= 12 {
                        start2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                    } else {
                        start2Label.text = "\(s) AM"
                    }
                }
            }
        } else if tag == 4 {
            let str = wDays[currenday][1]
            var array = str.split(separator: "-").map{String($0)}
            array[1] = s
            wDays[currenday][1] = array.joined(separator: "-")
            if s.count > 0 {
                let value = s.split(separator: ":")
                if value.count == 2 {
                    let hour = Int(value[0]) ?? 0
                    if hour >= 12 {
                        end2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                    } else {
                        end2Label.text = "\(s) AM"
                    }
                }
            }
        }
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
    
}

extension AddSchedualViewController: LoadingViewDelegate {
    func callbackContinue() {
        navigationController?.popViewController(animated: true)
    }
}

