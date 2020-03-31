//
//  AppDelegate.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if UserDefaults.standard.bool(forKey: USERDEFAULTS_KCPTUN_ON) {
            Kcptun.shared.start()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
}

