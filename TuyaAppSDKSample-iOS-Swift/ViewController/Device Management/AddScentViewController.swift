//
//  AddScentViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

let scentName = ["100": "Amore","101": "Apple Crate", "102": "Beach Cave",
                 "103": "Cactus Blossom", "104": "Cedar & Vine", "105": "Eclipse",
                 "106": "Golden Hour", "107": "Lavender Vanilla", "108": "Lemongrass",
                 "109": "Lighthouse", "110": "Linen & Lilies", "111": "Paradise Blue",
                 "112": "Seaworthy", "113": "Simply Citrus", "114": "Sleigh Ride",
                 "115": "Snowed Inn", "116": "Spiced Cider", "117": "Sweet Tobacco",
                 "118": "Sweet magnolia", "119": "Under the Tree", "120": "Welcome Home"]

class AddScentViewController: UIViewController {
    
    @IBOutlet weak var scentImageView: UIImageView!
    @IBOutlet weak var scentLabel: UILabel!
    var scent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = Int(scent) ?? 0
        if value < 100 || value > 120 {
            scent = "100"
        }
        scentImageView.image = UIImage(named: "f\(scent)")
        scentLabel.text = scentName[scent]
    }

    @IBAction func finish(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("DeviceMain"), object: (Int(scent) ?? 100) - 100)
        NotificationCenter.default.post(name: Notification.Name("TuneSettings"), object: (Int(scent) ?? 100) - 100)
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.type = 1
        present(vc, animated: true) {
            
        }
    }
    
}

extension AddScentViewController: LoadingViewDelegate {
    func callbackContinue() {
        let vcs = navigationController?.viewControllers ?? []
        for vc in vcs {
            if vc is TuneSettingsViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
        for vc in vcs {
            if vc is DeviceMainViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
}


