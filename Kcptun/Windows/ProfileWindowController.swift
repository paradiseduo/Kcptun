//
//  ProfileWindowController.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Cocoa

class ProfileWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var host: NSTextField!
    @IBOutlet weak var remotePort: NSTextField!
    @IBOutlet weak var crypt: NSComboBox!
    @IBOutlet weak var localPort: NSTextField!
    @IBOutlet weak var key: NSTextField!
    @IBOutlet weak var mode: NSComboBox!
    @IBOutlet weak var mtu: NSTextField!
    @IBOutlet weak var sndwnd: NSTextField!
    @IBOutlet weak var rcvwnd: NSTextField!
    @IBOutlet weak var datashard: NSTextField!
    @IBOutlet weak var parityshard: NSTextField!
    @IBOutlet weak var dscp: NSTextField!
    @IBOutlet weak var nocomp: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let profile = Profile.shared
        profile.loadProfile()
        self.host.stringValue = profile.host
        self.remotePort.stringValue = String(profile.remotePort)
        self.localPort.stringValue = String(profile.localPort)
        self.crypt.stringValue = profile.crypt
        self.key.stringValue = profile.key
        self.mode.stringValue = profile.mode
        self.mtu.stringValue = String(profile.mtu)
        self.sndwnd.stringValue = String(profile.sndwnd)
        self.rcvwnd.stringValue = String(profile.rcvwnd)
        self.datashard.stringValue = String(profile.datashard)
        self.parityshard.stringValue = String(profile.parityshard)
        self.dscp.stringValue = String(profile.dscp)
        self.nocomp.highlight(profile.nocomp)
    }
    
    
    @IBAction func cancelTap(_ sender: NSButton) {
        self.window?.close()
    }

    @IBAction func saveTap(_ sender: NSButton) {
        let profile = Profile.shared
        profile.host = self.host.stringValue
        profile.crypt = self.crypt.stringValue
        profile.key = self.key.stringValue
        profile.mode = self.mode.stringValue
        profile.nocomp = self.nocomp.isHighlighted
        if let i = Int(self.remotePort.stringValue), (1<=i && i<=65535) {
            profile.remotePort = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.localPort.stringValue), (1<=i && i<=65535) {
            profile.localPort = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.mtu.stringValue) {
            profile.mtu = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.sndwnd.stringValue) {
            profile.sndwnd = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.rcvwnd.stringValue) {
            profile.rcvwnd = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.datashard.stringValue) {
            profile.datashard = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.parityshard.stringValue) {
            profile.parityshard = i
        } else {
            self.shakeWindows()
            return
        }
        if let i = Int(self.dscp.stringValue) {
            profile.dscp = i
        } else {
            self.shakeWindows()
            return
        }
        Profile.shared.saveProfile()
        self.window?.close()
    }
    
    func shakeWindows() {
        let numberOfShakes:Int = 8
        let durationOfShake:Float = 0.5
        let vigourOfShake:Float = 0.05
        
        let frame:CGRect = (window?.frame)!
        let shakeAnimation = CAKeyframeAnimation()
        
        let shakePath = CGMutablePath()
        
        shakePath.move(to: CGPoint(x:NSMinX(frame), y:NSMinY(frame)))
        
        for _ in 1...numberOfShakes{
            shakePath.addLine(to: CGPoint(x: NSMinX(frame) - frame.size.width * CGFloat(vigourOfShake), y: NSMinY(frame)))
            shakePath.addLine(to: CGPoint(x: NSMinX(frame) + frame.size.width * CGFloat(vigourOfShake), y: NSMinY(frame)))
        }
        
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = CFTimeInterval(durationOfShake)
        window?.animations = ["frameOrigin":shakeAnimation]
        window?.animator().setFrameOrigin(window!.frame.origin)
    }
}
