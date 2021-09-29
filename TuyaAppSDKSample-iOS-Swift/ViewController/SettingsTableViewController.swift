//
//  SettingsTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit
import SafariServices

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 130)
        usernameLabel.text = TuyaSmartUser.sharedInstance().nickname
        let username = UserDefaults.standard.string(forKey: "UserName") ?? ""
        if username.count > 0 {
            usernameLabel.text = username
        }
        emailLabel.text = TuyaSmartUser.sharedInstance().email
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 3
        settingsLabel.addGestureRecognizer(tap)
        settingsLabel.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        ShareManager.shareFileHandler { type, result, value, error in
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let iv = cell.contentView.viewWithTag(1) as? UIImageView {
            iv.image = UIImage(named: icons[indexPath.row])
        }
        if let lbl = cell.contentView.viewWithTag(2) as? UILabel {
            lbl.text = titles[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let myAccountVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
            navigationController?.pushViewController(myAccountVC, animated: true)
//        case 1:
//            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
//            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let faqVC = storyboard.instantiateViewController(withIdentifier: "FAQViewController")
            navigationController?.pushViewController(faqVC, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let contactUSVC = storyboard.instantiateViewController(withIdentifier: "ContactUSViewController")
            navigationController?.pushViewController(contactUSVC, animated: true)
        case 3:
            let vc = SFSafariViewController(url: URL(string: "https://wholehomescenting.com/terms/")!)
            present(vc, animated: true, completion: nil)
        case 4:
            let storyboard = UIStoryboard(name: "DualMode", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DualModeViewController") as! DualModeViewController
            vc.showSearching = true 
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("未实现")
        }
    }

}

extension SettingsTableViewController {
    var titles: [String] {
        return ["Account", "FAQs", "Contact Us", "Terms of Service"]
    }
    var icons: [String] {
        return ["user", "question", "chat", "terms"]
    }
}
