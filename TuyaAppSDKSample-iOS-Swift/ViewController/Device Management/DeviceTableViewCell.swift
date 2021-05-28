//
//  DeviceTableViewCell.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class DeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var scentLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var scentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func more(_ sender: Any) {
    }
    
    @IBAction func handleStartOrStop(_ sender: Any) {
    }
}
