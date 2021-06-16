//
//  LoginTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class LoginTableViewController: BaseTableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var accountTextField: MTextField!
    @IBOutlet weak var passwordTextField: MTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 150)
        tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 250)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let username = UserDefaults.standard.string(forKey: "UserName")
        if username?.count ?? 0 > 0 {
            TuyaSmartUser.sharedInstance().updateNickname(username!) {
                
            } failure: { error in
                
            }

        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let account = accountTextField.text ?? ""
        
        // Simply examine weather the account is an email address of a phone number. Tuya SDK will handle the validation.
        if account.contains("@") {
            login(by: .email)
        } else {
            login(by: .phone)
        }
    }
    
    // MARK: - Private Method
    private func login(by type: AccountType) {
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        switch type {
        case .email:
            TuyaSmartUser.sharedInstance().login(byEmail: countryCode,
                                                 email: account,
                                                 password: password) { [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc

            } failure: { [weak self] (error) in
                guard let self = self else { return }
                Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Login", comment: ""), message: error?.localizedDescription ?? "")
            }

        case .phone:
            TuyaSmartUser.sharedInstance().login(byPhone: countryCode, phoneNumber: account, password: password) { [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
                
            } failure: { [weak self] (error) in
                guard let self = self else { return }
                Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Login", comment: ""), message: error?.localizedDescription ?? "")
            }

        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            loginButton.sendActions(for: .touchUpInside)
        } else if indexPath.section == 2 {
            //forgetPasswordButton.sendActions(for: .touchUpInside)
        }
    }
}
