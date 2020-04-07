//
//  Configuration.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/4/2.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

// Kcptun Helper
let KCPTUN_START = Notification.Name("KCPTUN_START")
let KCPTUN_STOP = Notification.Name("KCPTUN_STOP")
let USERDEFAULTS_KCPTUN_ON = "KcptunOn"
let USERDEFAULTS_PROFILE = "Profile"

// Version Checker Helper
let _VERSION_XML_URL = "https://raw.githubusercontent.com/paradiseduo/Kcptun/master/Kcptun/Info.plist"
let _VERSION_XML_LOCAL:String = Bundle.main.bundlePath + "/Contents/Info.plist"

// Log Helper
let LOG_PATH = "/usr/local/var/log/kcptun"
let LOG_CLEAN_FINISH = Notification.Name("LOG_CLEAN_FINISH")

// Launcher Helper
let USERDEFAULTS_LAUNCH_AT_LOGIN = "USERDEFAULTS_LAUNCH_AT_LOGIN"
let KILL_LAUNCHER = Notification.Name("MacOS_Kcptun_KILL_LAUNCHER")
let LAUNCHER_APPID = "MacOS.Kcptun.StartAtLoginLauncher"

let ISSUES_URL = "https://github.com/paradiseduo/Kcptun/issues"
let RELEASE_URL = "https://github.com/paradiseduo/Kcptun/releases"
