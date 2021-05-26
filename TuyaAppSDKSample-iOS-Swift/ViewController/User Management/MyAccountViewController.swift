//
//  MyAccountViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceKit

class MyAccountViewController: UIViewController {
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var signoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signout(_ sender: UIButton) {
        let alertViewController = UIAlertController(title: NSLocalizedString("Logout", comment: "Confirm logout."), message: NSLocalizedString("You're going to log out this account.", comment: "User tapped the logout button."), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: NSLocalizedString("Logout", comment: "Confirm logout."), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            TuyaSmartUser.sharedInstance().loginOut {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
            } failure: {
                [weak self] (error) in
                   guard let self = self else { return }
                   Alert.showBasicAlert(on: self, with: NSLocalizedString("Failed to Log Out", comment: "Failed to Log Out"), message: error?.localizedDescription ?? "")
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel)
        
        alertViewController.popoverPresentationController?.sourceView = sender
        
        alertViewController.addAction(logoutAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }

}
