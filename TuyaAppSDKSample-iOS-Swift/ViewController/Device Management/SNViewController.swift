//
//  SNViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import Toaster

class SNViewController: UIViewController {
    @IBOutlet weak var snTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func continueNext(_ sender: Any) {
        guard let sn = snTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), sn.count > 0 else {
            Toast(text: "请输入SN").show()
            return
        }
        performSegue(withIdentifier: "DualMode", sender: self)
    }

}
