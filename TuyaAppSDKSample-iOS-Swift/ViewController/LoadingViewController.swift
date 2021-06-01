//
//  LoadingViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    weak var delegate: LoadingViewDelegate?
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            titleLabel.text = "Fragrance Updated!"
        } else if type == 2 {
            titleLabel.text = "Schedule Added!"
        }
    }

    @IBAction func handleTap(_ sender: Any) {
        delegate?.callbackContinue()
        dismiss(animated: true, completion: nil)
    }

}

protocol LoadingViewDelegate: NSObjectProtocol {
    func callbackContinue()
}
