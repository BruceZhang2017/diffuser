//
//  SettingsTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 130)
        usernameLabel.text = TuyaSmartUser.sharedInstance().userName
        emailLabel.text = TuyaSmartUser.sharedInstance().email
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
        case 1:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let faqVC = storyboard.instantiateViewController(withIdentifier: "FAQViewController")
            navigationController?.pushViewController(faqVC, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
            let contactUSVC = storyboard.instantiateViewController(withIdentifier: "ContactUSViewController")
            navigationController?.pushViewController(contactUSVC, animated: true)
        default:
            print("未实现")
        }
    }

}

extension SettingsTableViewController {
    var titles: [String] {
        return ["Account", "Tutorials and Videos", "FAQs", "Contact Us", "Terms of Service", "Connectivity"]
    }
    var icons: [String] {
        return ["user", "video", "question", "chat", "terms", "signal"]
    }
}
