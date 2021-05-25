//
//  MainViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class MainViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.clear
    }

    // MARK: - Private Method
    private func configureView() {
        loginButton.roundCorner(radius: 4)
        loginButton.backgroundColor = UIColor.hex(color: "#BB9BC5")
        registerButton.roundCorner(radius: 4)
        loginButton.setTitle("Get Started", for: .normal)
        registerButton.backgroundColor = UIColor.hex(color: "#ffffff")
        registerButton.layer.borderColor = UIColor.hex(color: "#BB9BC5").cgColor
        registerButton.layer.borderWidth = 1
        registerButton.setTitleColor(UIColor.hex(color: "#BB9BC5"), for: .normal)
        registerButton.setTitle("Sign In", for: .normal)
    }
}

extension UIColor {
    class func hex(color: String) -> UIColor {
        var colorString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
        if colorString.count < 6 {
            return UIColor.clear
        }
            
        if colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        if colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
            
        if colorString.count < 6 {
            return UIColor.clear
        }
            
        var rang = NSRange()
        rang.location = 0
        rang.length = 2
            
        let rString = (colorString as NSString).substring(with: rang)
        rang.location = 2
        let gString = (colorString as NSString).substring(with: rang)
        rang.location = 4
        let bString = (colorString as NSString).substring(with: rang)
            
        var r:UInt64 = 0, g:UInt64 = 0,b: UInt64 = 0
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
             
        return UIColor.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
}
