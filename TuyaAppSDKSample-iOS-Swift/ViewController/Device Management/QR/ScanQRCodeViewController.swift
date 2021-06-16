//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

public protocol LBXScanViewControllerDelegate: NSObjectProtocol {
    func scanFinished(scanResult: LBXScanResult, error: String?, type: Int)
}

public protocol QRRectDelegate {
    func drawwed()
}

class ScanQRCodeViewController: BaseViewController {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    var type = 0 // 0-scan qr, 1-scan pin
    // 返回扫码结果，也可以通过继承本控制器，改写该handleCodeResult方法即可
    open weak var scanResultDelegate: LBXScanViewControllerDelegate?

    open var delegate: QRRectDelegate?

    open var scanObj: LBXScanWrapper?

    // 启动区域识别功能
    open var isOpenInterestRect = false
    
    //连续扫码
    open var isSupportContinuous = false;

    // 识别码的类型
    public var arrayCodeType: [AVMetadataObject.ObjectType]?

    // 是否需要识别后的当前图像
    public var isNeedCodeImage = false

    // 相机启动提示文字
    public var readyString: String! = "loading"

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open func setNeedCodeImage(needCodeImg: Bool) {
        isNeedCodeImage = needCodeImg
    }

    // 设置框内识别
    open func setOpenInterestRect(isOpen: Bool) {
        isOpenInterestRect = isOpen
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == 1 {
            enterButton.setTitle("Enter my pin manually", for: .normal)
            scanLabel.text = "ADD MY SCENT"
            lineImageView.isHidden = true
            descLabel.text = "Scan QR code on fragrance bottle or enter 3 digit code"
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(ScanQRCodeViewController.startScan), with: nil, afterDelay: 0.3)
        
        let qrImageView = UIImageView().then {
            $0.image = UIImage(named: "QR_Scanner")
        }
        qrView.addSubview(qrImageView)
        qrImageView.snp.makeConstraints {
            $0.width.height.equalTo(85)
            $0.center.equalToSuperview()
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SNViewController else {
            return
        }
        vc.type = type
    }

    @objc open func startScan() {
        if scanObj == nil {
            // 指定识别几种码
            if arrayCodeType == nil {
                arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString,
                                 AVMetadataObject.ObjectType.ean13 as NSString,
                                 AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
            }

            scanObj = LBXScanWrapper(videoPreView: qrView,
                                     objType: arrayCodeType!,
                                     isCaptureImg: isNeedCodeImage,
                                     cropRect: qrView.bounds,
                                     success: { [weak self] (arrayResult) -> Void in
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        strongSelf.handleCodeResult(arrayResult: arrayResult)
                                     })
        }
        
        scanObj?.supportContinuous = isSupportContinuous;

        // 相机运行
        scanObj?.start()
    }
   

    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理，或者设置delegate作出相应处理
     */
    open func handleCodeResult(arrayResult: [LBXScanResult]) {
        guard let delegate = scanResultDelegate else {
            fatalError("you must set scanResultDelegate or override this method without super keyword")
        }
        
        if !isSupportContinuous {
            navigationController?.popViewController(animated: true)

        }
        
        if let result = arrayResult.first {
            delegate.scanFinished(scanResult: result, error: nil, type: type)
        } else {
            let result = LBXScanResult(str: nil, img: nil, barCodeType: nil, corner: nil)
            delegate.scanFinished(scanResult: result, error: "no scan result", type: type)
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scanObj?.stop()
    }
    
    @objc open func openPhotoAlbum() {
        LBXPermissions.authorizePhotoWith { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true, completion: nil)
        }
    }
}

//MARK: - 图片选择代理方法
extension ScanQRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = editedImage ?? originalImage else {
            showMsg(title: nil, message: NSLocalizedString("Identify failed", comment: "Identify failed"))
            return
        }
        let arrayResult = LBXScanWrapper.recognizeQRImage(image: image)
        if !arrayResult.isEmpty {
            handleCodeResult(arrayResult: arrayResult)
        }
    }
    
}

//MARK: - 私有方法
private extension ScanQRCodeViewController {
    
    func showMsg(title: String?, message: String?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
