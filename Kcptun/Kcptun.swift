//
//  Launch.swift
//  Kcptun
//
//  Created by ParadiseDuo on 2020/3/31.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class Kcptun {
    let kcptun = Bundle.main.path(forResource: "client_darwin_amd64", ofType: nil)
    static let shared = Kcptun()
    
    private var task: Process?
    
    func start() {
        if let t = self.task, t.isRunning {
            return
        }
        NotificationCenter.default.post(name: KCPTUN_START, object: nil)
        self.task = Process()
        CommandLine.async(task: self.task!, shellPath: self.kcptun!, arguments: Profile.shared.arguments()) { (finish) in
            print("Kcptun turn off!")
            NotificationCenter.default.post(name: KCPTUN_STOP, object: nil)
        }
    }
    
    func stop() {
        if let t = self.task {
            t.terminate()
        }
        self.task = nil
    }
}

