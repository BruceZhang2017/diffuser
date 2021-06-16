//
//  RegisterViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signIn(_ sender: Any) {
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is LoginTableViewController {
                navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginTableViewController")
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

extension CALayer {
    func setBorderColorFromUIColor(color: UIColor) {
        self.borderColor = color.cgColor
    }
}
