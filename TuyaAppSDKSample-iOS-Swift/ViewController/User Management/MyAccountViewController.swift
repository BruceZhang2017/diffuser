//
//  MyAccountViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceKit
import SafariServices

class MyAccountViewController: UIViewController {
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mAttribute = NSMutableAttributedString()
        mAttribute.append(NSAttributedString(string: "Please go to ", attributes: [.foregroundColor: UIColor.hex(color: "2D3748"), .font: UIFont.systemFont(ofSize: 14)]))
        mAttribute.append(NSAttributedString(string: "wholehomescenting.com", attributes: [.foregroundColor: UIColor.hex(color: "BB9BC5"), .font: UIFont.systemFont(ofSize: 14), .underlineStyle: NSUnderlineStyle.single.rawValue]))
        mAttribute.append(NSAttributedString(string: " to manage your account", attributes: [.foregroundColor: UIColor.hex(color: "2D3748"), .font: UIFont.systemFont(ofSize: 14)]))
        headLabel.attributedText = mAttribute
        headLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
        headLabel.addGestureRecognizer(tap)
        tabHeight.constant = UIDevice.isSameToIphoneX() ? 83 : 50
    }
    
    @IBAction func signout(_ sender: UIButton) {
        let alertViewController = UIAlertController(title: NSLocalizedString("Sign out", comment: "Confirm logout."), message: NSLocalizedString("Are you sure you want to sign out?", comment: "User tapped the logout button."), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: NSLocalizedString("Sign out", comment: "Confirm logout."), style: .destructive) { [weak self] (action) in
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
    
    @objc private func handleTap(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: "https://www.wholehomescenting.com")!)
        present(vc, animated: true, completion: nil)
    }

    @IBAction private func handleShowDeviceList(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("Main"), object: 0)
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    @IBAction private func handleShowSettings(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("Main"), object: 1)
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
