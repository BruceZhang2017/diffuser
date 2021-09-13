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
    @IBOutlet weak var addScentButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    weak var delegate: DeviceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func more(_ sender: Any) {
        delegate?.handleMore(tag: tag)
    }
    
    @IBAction func handleStartOrStop(_ sender: Any) {
        let button = sender as! UIButton
        delegate?.handleFunction(button: button, tag: tag)
    }
    
    @IBAction func addScent(_ sender: Any) {
        delegate?.addScent(tag: tag)
    }
}

protocol DeviceTableViewCellDelegate: NSObjectProtocol {
    func handleMore(tag: Int)
    func handleFunction(button: UIButton, tag: Int)
    func addScent(tag: Int)
}
