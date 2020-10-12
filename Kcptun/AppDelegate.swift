//
//  AppDelegate.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if UserDefaults.standard.bool(forKey: USERDEFAULTS_KCPTUN_ON) {
            Kcptun.shared.start()
        }
        
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == LAUNCHER_APPID }.isEmpty
        if isRunning {
            DistributedNotificationCenter.default().post(name: KILL_LAUNCHER, object: Bundle.main.bundleIdentifier!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    static func getLauncherStatus() -> Bool {
        return LoginServiceKit.isExistLoginItems()
    }
    
    static func setLauncherStatus(open: Bool) {
        if open {
            LoginServiceKit.addLoginItems()
        } else {
            LoginServiceKit.removeLoginItems()
        }
    }
}

