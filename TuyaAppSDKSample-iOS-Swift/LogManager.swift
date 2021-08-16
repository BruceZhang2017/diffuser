//
// * Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.

//
//  LogManager.swift
//  SoundCore
//
//  Created by ANKER on 2017/12/14.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import XCGLogger

let log = LogManager.sharedInstance.log

class LogManager: NSObject {
    static let sharedInstance = LogManager()
    let log = Log.default
    private var bOverWriteLogFile = true // 是否覆盖log文件 默认值为覆盖，如特殊要求不覆盖，可设置false
    
    override init() {
        super.init()
        
    }
    
    func setupLog() {
        guard let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        if bOverWriteLogFile {
            overwriteFile(path: filePath)
        } else {
            appendFile(path: filePath)
        }

    }
    
    private func overwriteFile(path: String) {
        log.setup(level: .info, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "\(path)/diffuser.log" as AnyObject)
    }
    
    private func appendFile(path: String) {
        let fileDestination = FileDestination(writeToFile: "\(path)/diffuser.log", identifier: "advancedLogger.fileDestination", shouldAppend: true, appendMarker: "-- Relauched App --")

        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true

        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue

        // Add the destination to the logger
        log.add(destination: fileDestination)

        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
    }
}


