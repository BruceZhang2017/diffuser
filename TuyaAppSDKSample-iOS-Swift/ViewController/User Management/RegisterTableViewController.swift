//
//  RegisterTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit

class RegisterTableViewController: BaseTableViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countryCodeTextField: MTextField!
    @IBOutlet weak var lastNameTextField: MTextField!
    @IBOutlet weak var accountTextField: MTextField!
    @IBOutlet weak var passwordTextField: MTextField!
    @IBOutlet weak var regDescLabel: UILabel!
    @IBOutlet weak var sendVerificationCodeButton: UIButton!
    private var bShowCode = false // 是否到显示验证码步骤
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        regDescLabel.isHidden = true
    }

    // MARK: - IBAction
    @IBAction func sendVerificationCode(_ sender: UIButton) {
        if bShowCode {
            registerTapped()
            return
        }
        let account = accountTextField.text ?? ""
        sendVerificationCode(by: .email)
    }
    
    func registerTapped() {
        let account = accountTextField.text ?? ""

        if account.contains("@") {
            registerAccount(by: .email)
        } else {
            registerAccount(by: .phone)
        }
    }
    
    // MARK: - Private Method
    private func sendVerificationCode(by type: AccountType) {
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        let account = accountTextField.text ?? ""
        if !validateEmail(email: account) {
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
                
            }
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Register", comment: ""), message: NSLocalizedString("Please enter a valid email address", comment: ""), actions: [action])
            return
        }
        let name = (countryCodeTextField.text ?? "") + " " + (lastNameTextField.text ?? "")
        UserDefaults.standard.setValue(name, forKey: "UserName")
        UserDefaults.standard.synchronize()
        TuyaSmartUser.sharedInstance().sendVerifyCode(byRegisterEmail: countryCode, email: account) {  [weak self] in
            guard let self = self else { return }
            self.regDescLabel.text = "Enter the 6-digit code that was sent to \(account)"
            self.regDescLabel.isHidden = false
            self.lastNameTextField.isHidden = true
            self.accountTextField.isHidden = true
            self.passwordTextField.isHidden = true
            self.countryCodeTextField.text = nil
            self.countryCodeTextField.placeholder = "Verification Code"
            self.bShowCode = true
            self.sendVerificationCodeButton.setTitle("Sign Up", for: .normal)
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Sent Verification Code", comment: ""), message: errorMessage)
        }
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func registerAccount(by type: AccountType) {
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let verificationCode = countryCodeTextField.text ?? ""
        if verificationCode.count != 6 {
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
                
            }
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Invalid Code", comment: ""), message: NSLocalizedString("Please enter the 6-digit code that was sent to \(account)", comment: ""), actions: [action])
            return
        }
        TuyaSmartUser.sharedInstance().register(byEmail: countryCode, email: account, password: password, code: verificationCode) { [weak self] in
            guard let self = self else { return }
            
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Registration Successful", comment: ""), message: NSLocalizedString("An account has been created for \(account)", comment: ""), actions: [action])
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Register", comment: ""), message: errorMessage)
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, indexPath.row == 4 {
            sendVerificationCodeButton.sendActions(for: .touchUpInside)
        }

    }
    
}
