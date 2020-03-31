//
//  Profile.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 MacClient. All rights reserved.
//

import Foundation

class Profile {
    
    static let shared = Profile()
    
    var host: String = "127.0.0.1"
    var remotePort: Int = 29900
    var localPort: Int = 1087
    var crypt: String = "aes"
    var key: String = "password"
    var mode: String = "fast"
    var mtu: Int = 1350
    var sndwnd: Int = 512
    var rcvwnd: Int = 512
    var datashard: Int = 10
    var parityshard: Int = 3
    var dscp: Int = 0
    var nocomp: Bool = true
    
    var json: [String: AnyObject] {
        get {
            let conf:[String: AnyObject] = ["host": "\(self.host)" as AnyObject,
                                            "localPort": NSNumber(value: self.localPort) as AnyObject,
                                            "remotePort": NSNumber(value: self.remotePort) as AnyObject,
                                            "key": self.key as AnyObject,
                                            "crypt": self.crypt as AnyObject,
                                            "mode": self.mode as AnyObject,
                                            "mtu": NSNumber(value: self.mtu) as AnyObject,
                                            "sndwnd": NSNumber(value: self.sndwnd) as AnyObject,
                                            "rcvwnd": NSNumber(value: self.rcvwnd) as AnyObject,
                                            "datashard": NSNumber(value: self.datashard) as AnyObject,
                                            "parityshard": NSNumber(value: self.parityshard) as AnyObject,
                                            "dscp": NSNumber(value: self.dscp) as AnyObject,
                                            "nocomp": NSNumber(value: self.nocomp) as AnyObject
                                            ]
            return conf
        }
    }
    
    public func saveProfile() {
        let user = UserDefaults.standard
        user.setValue(self.json, forKey: USERDEFAULTS_PROFILE)
        user.synchronize()
        Kcptun.shared.stop()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            Kcptun.shared.start()
        }
    }
    
    public func loadProfile() {
        if let p = UserDefaults.standard.value(forKey: USERDEFAULTS_PROFILE) as? [String: AnyObject] {
            self.host = p["host"] as! String
            self.remotePort = (p["remotePort"] as! NSNumber).intValue
            self.localPort = (p["localPort"] as! NSNumber).intValue
            self.key = p["key"] as! String
            self.crypt = p["crypt"] as! String
            self.mode = p["mode"] as! String
            self.mtu = (p["mtu"] as! NSNumber).intValue
            self.sndwnd = (p["sndwnd"] as! NSNumber).intValue
            self.rcvwnd = (p["rcvwnd"] as! NSNumber).intValue
            self.datashard = (p["datashard"] as! NSNumber).intValue
            self.parityshard = (p["parityshard"] as! NSNumber).intValue
            self.dscp = (p["dscp"] as! NSNumber).intValue
            self.nocomp = (p["nocomp"] as! NSNumber).boolValue
        }
    }
    
    func arguments() -> [String] {
        if self.nocomp {
            return ["-r","\(self.host):\(self.remotePort)",
                "-l",":\(self.localPort)",
                "--mode",self.mode,
                "--key",self.key,
                "--mtu","\(self.mtu)",
                "--sndwnd","\(self.sndwnd)",
                "--rcvwnd","\(self.rcvwnd)",
                "--datashard","\(self.datashard)",
                "--dscp","\(self.dscp)",
                "--nocomp"
            ]
        } else {
            return ["-r","\(self.host):\(self.remotePort)",
                "-l",":\(self.localPort)",
                "--mode",self.mode,
                "--key",self.key,
                "--mtu","\(self.mtu)",
                "--sndwnd","\(self.sndwnd)",
                "--rcvwnd","\(self.rcvwnd)",
                "--datashard","\(self.datashard)",
                "--dscp","\(self.dscp)"
            ]
        }
    }
}
