//
//  TuneSettingsViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class TuneSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func deleteSchedual(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this schedule?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { action in
            
        })
        alert.addAction(delete)
        delete.setValue(UIColor.red, forKey: "backgroundColor")
        
        present(alert, animated: true, completion: nil)
    }

}
