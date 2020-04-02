//
//  Configuration.swift
//  Kcptun
//
//  Created by YouShaoduo on 2020/4/2.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

let KCPTUN_START = Notification.Name("KCPTUN_START")
let KCPTUN_STOP = Notification.Name("KCPTUN_STOP")
let USERDEFAULTS_KCPTUN_ON = "KcptunOn"
let USERDEFAULTS_PROFILE = "Profile"

let _VERSION_XML_URL = "https://raw.githubusercontent.com/paradiseduo/Kcptun/master/Kcptun/Info.plist"
let _VERSION_XML_LOCAL:String = Bundle.main.bundlePath + "/Contents/Info.plist"

let LOG_PATH = "/usr/local/var/log/kcptun"

let LOG_CLEAN_FINISH = Notification.Name("LOG_CLEAN_FINISH")
