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
    @IBOutlet weak var launchItem: NSMenuItem!
    
    var profileW: ProfileWindowController!
    var logW: LogWindowController!
    var toastW: ToastWindowController!
    
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
            switchLabel.title = "Kcptun: On".localized
            switchLabel.image = NSImage(named: NSImage.statusAvailableName)
            toggleRunning.title = "Turn Kcptun Off".localized
            
            let icon = NSImage(named: "open")
            statusItem.button?.image = icon
            statusItem.menu = statusMenu
            
        } else {
            switchLabel.title = "Kcptun: Off".localized
            switchLabel.image = NSImage(named: NSImage.statusUnavailableName)
            toggleRunning.title = "Turn Kcptun On".localized
            
            let icon = NSImage(named: "close")
            statusItem.button?.image = icon
            statusItem.menu = statusMenu
            
        }
        statusItem.image?.isTemplate = true
        self.launchItem.state = NSControl.StateValue(rawValue: AppDelegate.getLauncherStatus() ? 1 : 0)
    }
    
    @IBAction func powerSwitch(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: USERDEFAULTS_KCPTUN_ON)
        if isOn {
            defaults.set(false, forKey: USERDEFAULTS_KCPTUN_ON)
            Kcptun.shared.stop()
            self.makeToast("Kcptun OFF")
        } else {
            defaults.set(true, forKey: USERDEFAULTS_KCPTUN_ON)
            Kcptun.shared.start()
            self.makeToast("Kcptun ON")
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
        CommandLine.async(task: Process(), command: "rm -rf \(LOG_PATH)", terminate:  { (finish) in
            print("CleanLog finish")
            NotificationCenter.default.post(name: LOG_CLEAN_FINISH, object: nil)
            self.makeToast("Logs Cleand")
        })
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
                    NSWorkspace.shared.open(URL(string: RELEASE_URL)!)
                }
            }
        }
    }
    
    @IBAction func launchAtLogin(_ sender: NSMenuItem) {
        if UserDefaults.standard.bool(forKey: USERDEFAULTS_LAUNCH_AT_LOGIN) {
            AppDelegate.setLauncherStatus(open: false)
        } else {
            AppDelegate.setLauncherStatus(open: true)
        }
        self.updateMainMenu()
    }
    
    @IBAction func feedbackTap(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: ISSUES_URL)!)
    }
    
    @IBAction func aboutMe(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(sender);
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func makeToast(_ message: String) {
        if self.toastW != nil {
            self.toastW.close()
        }
        let c = ToastWindowController.init(windowNibName: "ToastWindowController")
        self.toastW = c
        c.message = message
        c.showWindow(self)
        c.fadeInHud()
    }
}
