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
        } else if type == 3 {
            titleLabel.text = "Schedule Cleared!"
        } else if type >= 10 {
            let weekTitles = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            titleLabel.text = "Invalid/Overlapping\nschedule:\(weekTitles[type - 10])"
            continueButton.setTitle("Continue", for: .normal)
        }
        view.tag = type
    }

    @IBAction func handleTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.callbackContinue(tag: view.tag)
    }

}

protocol LoadingViewDelegate: NSObjectProtocol {
    func callbackContinue(tag: Int)
}
