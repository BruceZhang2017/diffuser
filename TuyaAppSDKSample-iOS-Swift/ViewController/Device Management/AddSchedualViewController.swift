//
//  AddSchedualViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class AddSchedualViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    var startTime = ""
    var endTime = ""
    var picker: ShuKeTimerPickerView?
    
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
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectDay(_ sender: Any) {
    }
    
    @IBAction func confirm(_ sender: Any) {
        
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
                if hour > 12 {
                    startLabel.text = "\(String(format: "%2d", hour - 12)):\(value[1]) PM"
                } else {
                    startLabel.text = "\(startTime) AM"
                }
            }
        } else {
            endTime = resultString
            let value = endTime.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour > 12 {
                    endLabel.text = "\(String(format: "%2d", hour - 12)):\(value[1]) PM"
                } else {
                    endLabel.text = "\(endTime) AM"
                }
            }
        }
    }
}
