//
//  StatusMenuManager.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Cocoa

class StatusMenuManager: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var switchLabel: NSMenuItem!
    @IBOutlet weak var toggleRunning: NSMenuItem!
    
    var profileW: ProfileWindowController!
    var logW: LogWindowController!
    
    override func awakeFromNib() {
        updateMainMenu()
        NotificationCenter.default.addObserver(forName: KCPTUN_START, object: nil, queue: OperationQueue.main) { (noti) in
            if !UserDefaults.standard.bool(forKey: USERDEFAULTS_KCPTUN_ON) {
                UserDefaults.standard.set(true, forKey: USERDEFAULTS_KCPTUN_ON)
                UserDefaults.standard.synchronize()
                self.updateMainMenu()
            }
        }
        NotificationCenter.default.addObserver(forName: KCPTUN_STOP, object: nil, queue: OperationQueue.main) { (noti) in
            if UserDefaults.standard.bool(forKey: USERDEFAULTS_KCPTUN_ON) {
                UserDefaults.standard.set(false, forKey: USERDEFAULTS_KCPTUN_ON)
                UserDefaults.standard.synchronize()
                self.updateMainMenu()
            }
        }
    }
    
    func updateMainMenu() {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: USERDEFAULTS_KCPTUN_ON)
        if isOn {
            switchLabel.title = "Kcptun: On"
            switchLabel.image = NSImage(named: NSImage.statusAvailableName)
            toggleRunning.title = "Turn Kcptun Off"
            
            let icon = NSImage(named: "open")
            statusItem.button?.image = icon
            statusItem.menu = statusMenu
        } else {
            switchLabel.title = "Kcptun: Off"
            switchLabel.image = NSImage(named: NSImage.statusUnavailableName)
            toggleRunning.title = "Turn Kcptun On"
            
            let icon = NSImage(named: "close")
            statusItem.button?.image = icon
            statusItem.menu = statusMenu
        }
    }
    
    @IBAction func powerSwitch(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: USERDEFAULTS_KCPTUN_ON)
        if isOn {
            defaults.set(false, forKey: USERDEFAULTS_KCPTUN_ON)
            Kcptun.shared.stop()
        } else {
            defaults.set(true, forKey: USERDEFAULTS_KCPTUN_ON)
            Kcptun.shared.start()
        }
        defaults.synchronize()
        updateMainMenu()
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        Kcptun.shared.stop()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            NSApplication.shared.terminate(self)
        }
    }
    
    @IBAction func showLog(_ sender: NSMenuItem) {
        if self.logW != nil {
            self.logW.close()
        }
        let c = LogWindowController(windowNibName: "LogWindowController")
        self.logW = c
        c.showWindow(self)
        c.window?.center()
        c.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func cleanLogs(_ sender: NSMenuItem) {
        CommandLine.async(task: Process(), command: "rm -rf \(LOG_PATH)") { (finish) in
            print("CleanLog finish")
            NotificationCenter.default.post(name: LOG_CLEAN_FINISH, object: nil)
        }
    }
    
    
    @IBAction func setting(_ sender: NSMenuItem) {
        if self.profileW != nil {
            self.profileW.close()
        }
        let c = ProfileWindowController(windowNibName: "ProfileWindowController")
        self.profileW = c
        c.showWindow(self)
        c.window?.center()
        c.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func checkUpdate(_ sender: NSMenuItem) {
        let versionChecker = VersionChecker()
        DispatchQueue.global().async {
            let newVersion = versionChecker.checkNewVersion()
            DispatchQueue.main.async {
                let alertResult = versionChecker.showAlertView(Title: newVersion["Title"] as! String, SubTitle: newVersion["SubTitle"] as! String, ConfirmBtn: newVersion["ConfirmBtn"] as! String, CancelBtn: newVersion["CancelBtn"] as! String)
                if (newVersion["newVersion"] as! Bool && alertResult == 1000){
                    NSWorkspace.shared.open(URL(string: "https://github.com/paradiseduo/Kcptun/releases")!)
                }
            }
        }
    }
    
    @IBAction func feedbackTap(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://github.com/paradiseduo/Kcptun/issues")!)
    }
    
    @IBAction func aboutMe(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(sender);
        NSApp.activate(ignoringOtherApps: true)
    }
}
