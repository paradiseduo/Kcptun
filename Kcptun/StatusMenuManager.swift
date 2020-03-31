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
    
    var ctrl: ProfileWindowController!
    
    override func awakeFromNib() {
        updateMainMenu()
    }
    
    func updateMainMenu() {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "KcptunOn")
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
        let isOn = defaults.bool(forKey: "KcptunOn")
        if isOn {
            defaults.set(false, forKey: "KcptunOn")
            Kcptun.shared.stop()
        } else {
            defaults.set(true, forKey: "KcptunOn")
            Kcptun.shared.start()
        }
        defaults.synchronize()
        updateMainMenu()
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func setting(_ sender: NSMenuItem) {
        ctrl = ProfileWindowController(windowNibName: "ProfileWindowController")
        ctrl.showWindow(self)
        ctrl.window?.center()
        ctrl.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func aboutMe(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(sender);
        NSApp.activate(ignoringOtherApps: true)
    }
}
