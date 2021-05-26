//
//  ContactUSViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class ContactUSViewController: UIViewController {
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrString = NSMutableAttributedString()
        attrString.append(NSAttributedString(string: "(855) 723-6863", attributes: [.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.hex(color: "BB9BC5")]))
        attrString.append(NSAttributedString(string: "\n277 E 950 S Orem, UT 84058", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.hex(color: "000000")]))
        phoneLabel.attributedText = attrString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
