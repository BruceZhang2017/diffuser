//
//  SNViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import Toaster

class SNViewController: BaseViewController {
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
            snLabel.text = "Enter Fragrance Code Manually"
            snTextfield.placeholder = "Fragrance Code"
            descLabel.text = "The Fragrance Code can be found on the bottle"
        }
    }
    
    @IBAction private func continueNext(_ sender: Any) {
        guard let sn = snTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), sn.count > 0 else {
            return
        }
        if type == 1 {
            let value = Int(sn) ?? 0
            if value < 100 || value > 120 {
                Toast(text: "Invalid Fragrance Code").show()
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

extension SNViewController: UITextFieldDelegate {
    func textField(_ textField:UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char < 48 {return false }
            if char > 57 {return false }
        }
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8) ?? 0) - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > 3 { return false }
        return true
    }
}
