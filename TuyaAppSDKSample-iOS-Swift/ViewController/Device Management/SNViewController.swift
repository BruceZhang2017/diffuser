//
//  SNViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import Toaster

class SNViewController: UIViewController {
    @IBOutlet weak var snLabel: UILabel!
    @IBOutlet weak var snTextfield: MTextField!
    @IBOutlet weak var descLabel: UILabel!
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == 1 {
            snLabel.text = "ENTER PIN NUMBER MANUALLY"
            snTextfield.placeholder = "PIN Number"
            descLabel.text = "The PIN Number can be found on the bottle label"
        }
    }
    
    @IBAction private func continueNext(_ sender: Any) {
        guard let sn = snTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), sn.count > 0 else {
            Toast(text: "请输入").show()
            return
        }
        if type == 1 {
            let value = Int(sn) ?? 0
            if value < 100 || value > 120 {
                Toast(text: "请输入100-120之间的数字").show()
                return
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddScentViewController") as? AddScentViewController
            vc?.scent = sn 
            navigationController?.pushViewController(vc!, animated: true)
        } else {
            performSegue(withIdentifier: "DualMode", sender: self)
        }
    }

}
