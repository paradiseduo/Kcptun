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
        async(shellPath: kcptun!, arguments: Profile.shared.arguments(), output: { (line) in
            print(line)
        }) { (finish) in
            print("Kcptun finish!")
        }
    }
    
    func stop() {
        if let t = self.task {
            t.terminate()
        }
        task = nil
    }

    func shellOutput() {
        if let t = self.task {
            let outputPipe = Pipe()
            t.standardOutput = outputPipe
            outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil) { (noti) in
                let output = outputPipe.fileHandleForReading.availableData
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                if outputString != ""{
                    print(outputString)
                }
                outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
        }
    }
    
    func async(command: String, output: ((String) -> Void)? = nil, terminate: ((Int) -> Void)? = nil) {
        let utf8Command = "export LANG=en_US.UTF-8\n" + command
        async(shellPath: "/bin/bash", arguments: ["-c", utf8Command], output:output, terminate:terminate)
    }
    
    func async(shellPath: String, arguments: [String]? = nil, output: ((String) -> Void)? = nil, terminate: ((Int) -> Void)? = nil) {
        DispatchQueue.global().async {
            self.task = Process()
            let pipe = Pipe()
            let outHandle = pipe.fileHandleForReading
            
            var environment = ProcessInfo.processInfo.environment
            environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            self.task!.environment = environment
            
            if arguments != nil {
                self.task!.arguments = arguments!
            }
            
            self.task!.launchPath = shellPath
            self.task!.standardOutput = pipe
            
            outHandle.waitForDataInBackgroundAndNotify()
            var obs1 : NSObjectProtocol!
            obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {  notification -> Void in
                let data = outHandle.availableData
                if data.count > 0 {
                    if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        DispatchQueue.main.async {
                            output?(str as String)
                        }
                    }
                    outHandle.waitForDataInBackgroundAndNotify()
                } else {
                    NotificationCenter.default.removeObserver(obs1 as Any)
                    pipe.fileHandleForReading.closeFile()
                }
            }

            var obs2 : NSObjectProtocol!
            obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: nil, queue: nil) { notification -> Void in
                DispatchQueue.main.async {
                    terminate?(Int(0))
                }
                NotificationCenter.default.removeObserver(obs2 as Any)
            }
            
            self.task!.launch()
            self.task!.waitUntilExit()
        }
    }
}

