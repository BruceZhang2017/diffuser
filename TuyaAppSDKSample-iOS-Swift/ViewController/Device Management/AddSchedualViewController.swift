//
//  AddSchedualViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceCoreKit
import Toaster

class AddSchedualViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    var startTime = ""
    var endTime = ""
    var picker: ShuKeTimerPickerView?
    var device: TuyaSmartDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLabel.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleStart))
        tap1.numberOfTapsRequired = 1
        startLabel.addGestureRecognizer(tap1)
        endLabel.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleEnd))
        tap2.numberOfTapsRequired = 1
        endLabel.addGestureRecognizer(tap2)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let date = Date()
        startTime = dateformatter.string(from: date)
        endTime = startTime
        
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
        
        for (i, value) in days.enumerated() {
            buttons[i].isSelected = value > 0
        }
    }
    
    @IBAction func selectDay(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
    }
    
    @IBAction func confirm(_ sender: Any) {
        if startTime.count == 0 || endTime.count == 0 || startTime == endTime {
            Toast(text: "请选择时间").show()
            return
        }
//        if startTime.compare(endTime) != .orderedAscending {
//            Toast(text: "开始时间不能晚于结束时间").show()
//            return
//        }
        var selected = false
        for button in buttons {
            if button.isSelected {
                selected = true
                break
            }
        }
        if !selected {
            Toast(text: "星期几必须需要").show()
            return
        }
        
        var value = "8A"
        var d = 0
        for (i, day) in buttons.enumerated() {
            d += ((day.isSelected ? 1 : 0) << i)
        }
        let st = NSString(format:"%2X", d) as String
        print("天数：\(d) \(st)")
        value += st
        value += "0c060624"
        for schedual in scheduals {
            value += schedual.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "-", with: "")
        }
        let s = startTime.replacingOccurrences(of: ":", with: "")
        let e = endTime.replacingOccurrences(of: ":", with: "")
        value += "\(s)\(e)"
        if scheduals.count + 1 < 5 {
            let count = 5 - scheduals.count - 1
            for _ in 0..<count {
                value += "00000000"
            }
        }
        publishMessage(with: ["8" : value])
    }
    
    private func showAlert() {
        for i in 0..<7 {
            let v = buttons[i].isSelected ? 1 : 0
            days[i] = Int(v)
        }
        scheduals.append("\(startTime)-\(endTime)")
        
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
            self?.showAlert()
        }, failure: { (error) in
            let errorMessage = error?.localizedDescription ?? ""
            SVProgressHUD.showError(withStatus: errorMessage)
        })
    }
    
    @objc private func handleStart() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        var date: Date
        if startTime.count > 0 {
            date = dateformatter.date(from: startTime) ?? Date()
        } else {
            date = Date()
        }
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "选择时间")
        picker?.setDatePickerDateFormat("HH:mm")
        picker?.delegate = self
        picker?.show()
        picker?.tag = 1
    }
    
    @objc private func handleEnd() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        var date: Date
        if endTime.count > 0 {
            date = dateformatter.date(from: endTime) ?? Date()
        } else {
            date = Date()
        }
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "选择时间")
        picker?.setDatePickerDateFormat("HH:mm")
        picker?.delegate = self
        picker?.show()
        picker?.tag = 2
    }
}

extension AddSchedualViewController: ShuKeTimerPickerViewDelegate {
    func toobarDonBtnHaveClick(_ pickView: ShuKeTimerPickerView, resultString: String, atIndexof indexRow: Int) {
        if pickView.tag == 1 {
            startTime = resultString
            let value = startTime.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    startLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    startLabel.text = "\(startTime) AM"
                }
            }
        } else {
            endTime = resultString
            let value = endTime.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    endLabel.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    endLabel.text = "\(endTime) AM"
                }
            }
        }
    }
}

extension AddSchedualViewController: LoadingViewDelegate {
    func callbackContinue() {
        navigationController?.popViewController(animated: true)
    }
}
