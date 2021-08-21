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
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var start2Label: UILabel!
    @IBOutlet weak var end2Label: UILabel!
    var picker: ShuKeTimerPickerView?
    var device: TuyaSmartDevice?
    var currenday = 0
    var startTime: String = ""
    var endTime: String = ""
    var start2Time: String = ""
    var end2Time: String = ""
    var wDays: [[String]] = []
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wDays = weekdays
        startLabel.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleStart))
        tap1.numberOfTapsRequired = 1
        startLabel.addGestureRecognizer(tap1)
        endLabel.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleEnd))
        tap2.numberOfTapsRequired = 1
        endLabel.addGestureRecognizer(tap2)
        start2Label.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(handleStart2))
        tap3.numberOfTapsRequired = 1
        start2Label.addGestureRecognizer(tap3)
        end2Label.isUserInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(handleEnd2))
        tap4.numberOfTapsRequired = 1
        end2Label.addGestureRecognizer(tap4)
        
        for button in buttons {
            button.setTitleColor(UIColor.hex(color: "BB9BC5"), for: .selected)
        }
        
        refreshUI()
    }
    
    private func refreshUI() {
        startTime = String(wDays[currenday][0].split(separator: "-")[0])
        endTime = String(wDays[currenday][0].split(separator: "-")[1])
        start2Time = String(wDays[currenday][1].split(separator: "-")[0])
        end2Time = String(wDays[currenday][1].split(separator: "-")[1])
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
        
        for i in 0..<7 {
            buttons[i].isSelected = currenday == i
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
        publishMessage(with: ["8" : "6A0000\(s)"])
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
            publishMessage(with: ["8" : "6A0100\(s)"])
        }
        if i == 2 {
            var s = wDays[1][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0202\(s)"])
        }
        if i == 3 {
            var s = wDays[1][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0302\(s)"])
        }
        if i == 4 {
            var s = wDays[2][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0404\(s)"])
        }
        if i == 5 {
            var s = wDays[2][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0504\(s)"])
        }
        if i == 6 {
            var s = wDays[3][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0608\(s)"])
        }
        if i == 7 {
            var s = wDays[3][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0708\(s)"])
        }
        if i == 8 {
            var s = wDays[4][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0810\(s)"])
        }
        if i == 9 {
            var s = wDays[4][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0910\(s)"])
        }
        if i == 10 {
            var s = wDays[5][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0a20\(s)"])
        }
        if i == 11 {
            var s = wDays[5][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0b20\(s)"])
        }
        if i == 12 {
            var s = wDays[6][0]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0c40\(s)"])
        }
        if i == 13 {
            var s = wDays[6][1]
            s = s.replacingOccurrences(of: ":", with: "")
            s = s.replacingOccurrences(of: "-", with: "")
            publishMessage(with: ["8" : "6A0d40\(s)"])
        }
        if i == 14 {
            SVProgressHUD.dismiss()
            weekdays = wDays
            showAlert()
            i = 0
        }
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
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "Select Option")
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
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "Select Option")
        picker?.setDatePickerDateFormat("HH:mm")
        picker?.delegate = self
        picker?.show()
        picker?.tag = 2
    }
    
    @objc private func handleStart2() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        var date: Date
        if start2Time.count > 0 {
            date = dateformatter.date(from: start2Time) ?? Date()
        } else {
            date = Date()
        }
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "Select Option")
        picker?.setDatePickerDateFormat("HH:mm")
        picker?.delegate = self
        picker?.show()
        picker?.tag = 3
    }
    
    @objc private func handleEnd2() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        var date: Date
        if end2Time.count > 0 {
            date = dateformatter.date(from: end2Time) ?? Date()
        } else {
            date = Date()
        }
        picker = ShuKeTimerPickerView(datePickWith: date, datePickerMode: .time, isHaveNavControler: false, toolbarTitle: "Select Option")
        picker?.setDatePickerDateFormat("HH:mm")
        picker?.delegate = self
        picker?.show()
        picker?.tag = 4
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
            let str = wDays[currenday][0]
            var array = str.split(separator: "-").map{String($0)}
            array[0] = startTime
            wDays[currenday][0] = array.joined(separator: "-")
        } else if pickView.tag == 2 {
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
            let str = wDays[currenday][0]
            var array = str.split(separator: "-").map{String($0)}
            array[1] = endTime
            wDays[currenday][0] = array.joined(separator: "-")
        } else if pickView.tag == 3 {
            start2Time = resultString
            let value = start2Time.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    start2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    start2Label.text = "\(start2Time) AM"
                }
            }
            let str = wDays[currenday][1]
            var array = str.split(separator: "-").map{String($0)}
            array[0] = start2Time
            wDays[currenday][1] = array.joined(separator: "-")
        } else if pickView.tag == 4 {
            end2Time = resultString
            let value = end2Time.split(separator: ":")
            if value.count == 2 {
                let hour = Int(value[0]) ?? 0
                if hour >= 12 {
                    end2Label.text = "\(String(format: "%02d", hour - 12)):\(value[1]) PM"
                } else {
                    end2Label.text = "\(end2Time) AM"
                }
            }
            let str = wDays[currenday][1]
            var array = str.split(separator: "-").map{String($0)}
            array[1] = end2Time
            wDays[currenday][1] = array.joined(separator: "-")
        }
    }
}

extension AddSchedualViewController: LoadingViewDelegate {
    func callbackContinue() {
        navigationController?.popViewController(animated: true)
    }
}
