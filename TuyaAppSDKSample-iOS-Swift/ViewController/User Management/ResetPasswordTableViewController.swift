//
//  ResetPasswordTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit

class ResetPasswordTableViewController: BaseTableViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    private var bSendCode = true // 发送验证码
    private var email = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTextField.isHidden = true
        passwordTextField.isHidden = true
        countryCodeTextField.placeholder = "Email Address"
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 180)
        tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 150)
    }

    // MARK: - IBAction
    func sendVerificationCode() {
        let countryCode = "01"
        let account = countryCodeTextField.text ?? ""
        
        TuyaSmartUser.sharedInstance().sendVerifyCode(byEmail: countryCode, email: account) { [weak self] in
            guard let self = self else { return }
            self.refreshUI()
            self.email = account
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Invalid Email", comment: ""), message: NSLocalizedString("The email address entered does not exist or is not associated with an account.", comment: ""), actions: [UIAlertAction(title: "OK", style: .cancel, handler: { action in
                
            }), UIAlertAction(title: "Sign Up", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.pushToReg()
            })])
        }
    }
    
    func pushToReg() {
        let sb = UIStoryboard(name: "Register", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegisterViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshUI() {
        bSendCode = false
        countryCodeTextField.text = nil
        accountTextField.isHidden = false
        passwordTextField.isHidden = false
        countryCodeTextField.placeholder = "Verification Code"
        resetButton.setTitle("Sign In", for: .normal)
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        if bSendCode {
            sendVerificationCode()
            return
        }
        let countryCode = "01"
        let password = passwordTextField.text ?? ""
        let npassword = accountTextField.text ?? ""
        let verificationCode = countryCodeTextField.text ?? ""
        if password.count == 0 || password != npassword {
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Invalid Password", comment: ""), message: "")
            return
        }
        TuyaSmartUser.sharedInstance().resetPassword(byEmail: countryCode, email: email, newPassword: npassword, code: verificationCode) { [weak self] in
            guard let self = self else { return }
            Alert.showBasicAlert(on: self, with: nil, message: NSLocalizedString("Password Reset Successfully ", comment: ""), actions: [UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] action in
                self?.navigationController?.popViewController(animated: true)
            })])
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Reset Password", comment: ""), message: errorMessage)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1, indexPath.row == 1 {
            
        } else if indexPath.section == 2 {
            resetButton.sendActions(for: .touchUpInside)
        }

    }
}
