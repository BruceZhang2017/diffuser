//
//  TutorialViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import SafariServices

class TutorialViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.layer.setBorderColorFromUIColor(color: UIColor.white)
    }
    
    @IBAction func skip(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
        present(vc, animated: true, completion: nil)
    }

}
