//
//  AddScentViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

let scentName = ["AMR": "Amore","APL": "Apple Crate", "BEA": "Beach Cave",
                 "CAB": "Cactus Blossom", "CEV": "Cedar & Vine", "ECL": "Eclipse",
                 "LAV": "Lavender Vanilla", "LMG": "Lemongrass",
                 "LTH": "Lighthouse", "LIN": "Linen & Lilies", "PAR": "Paradise Blue",
                 "SEA": "Seaworthy", "SIM": "Simply Citrus", "SLR": "Sleigh Ride",
                 "SNO": "Snowed Inn", "SPC": "Spiced Cider", "SWT": "Sweet Tobacco",
                 "SMG": "Sweet magnolia", "UND": "Under the Tree", "WEL": "Welcome Home"]
let scentPNG = ["AMR": "amore-product-image-min","APL": "apple-crate-product-image-min", "BEA": "beach-cove-product-image-min",
                 "CAB": "cactus-blossom-product-image-min", "CEV": "cedar-vine-product-image-min", "ECL": "eclipse-product-image-min",
                 "LAV": "lavender-vanilla-product-image-min", "LMG": "lemongrass-product-image-min",
                 "LTH": "lighthouse-product-image-min", "LIN": "linen-lilies-product-image-min", "PAR": "paradise-blue-product-image-min",
                 "SEA": "seaworthy-product-image-min", "SIM": "simply-citrus-product-image-min", "SLR": "sleigh-ride-product-image-min",
                 "SNO": "snowed-inn-product-image-min", "SPC": "spiced-cider-product-image-min", "SWT": "sweet-tobacco-product-image-min",
                 "SMG": "sweet-magnolia-product-image-min", "UND": "under-the-tree-product-image-min", "WEL": "under-the-tree-product-image-min"]

class AddScentViewController: UIViewController {
    
    @IBOutlet weak var scentImageView: UIImageView!
    @IBOutlet weak var scentLabel: UILabel!
    var scent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        scentImageView.image = UIImage(named: scentPNG[scent] ?? "amore-product-image-min")
        scentLabel.text = scentName[scent]
    }

    @IBAction func finish(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("DeviceMain"), object: scent)
        NotificationCenter.default.post(name: Notification.Name("TuneSettings"), object: scent)
//        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.delegate = self
//        vc.type = 1
//        present(vc, animated: true) {
//
//        }
        callbackContinue(tag: 0)
    }
    
}

extension AddScentViewController: LoadingViewDelegate {
    func callbackContinue(tag: Int) {
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


