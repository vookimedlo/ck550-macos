//
//  CK550HIDDevice.swift
//  ck550-cli
//
//  Created by Michal Duda on 27/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CK550HIDDevice : HIDDevice {
    private var waitForResponseMutex = DispatchSemaphore(value: 0)
    private var commandAccessMutex = DispatchSemaphore(value: 1)
    private var command: CK550HIDDeviceCommand?
    
    required init(manager: IOHIDManager, device: IOHIDDevice) {
        super.init(manager: manager, device: device)
    }
    
    override func dataReceived(buffer: [uint8]) -> Void {
        print(Data(buffer).hexString())
        
        commandAccessMutex.wait()
        if let command = self.command {
            command.addIncomingResponse(buffer)
            if !command.waitsForAnotherResponse() {
                waitForResponseMutex.signal()
            }
        }
        commandAccessMutex.signal()
    }
    
    override func write(command: [uint8]) -> Bool {
        let result = super.write(command: command)
        return result
    }
    
    func write(command: CK550HIDDeviceCommand) -> Void {
        let shallWait = command.waitsForAnotherResponse()
        if shallWait {
            waitForResponseMutex = DispatchSemaphore(value: 0)
            commandAccessMutex.wait()
            self.command = command
            commandAccessMutex.signal()
        }
        var packet = command.nextMessage()
        while packet != nil {
            if !write(command: packet!) {
                commandAccessMutex.wait()
                command.reportWriteFailure()
                self.command = nil
                commandAccessMutex.signal()
                return
            }
            packet = command.nextMessage()
        }
        
        if shallWait {
            if .timedOut == waitForResponseMutex.wait(timeout: .now() + .milliseconds(500)) {
                commandAccessMutex.signal()
                command.reportResponseTimeout()
                commandAccessMutex.wait()
            }
        }
        
        commandAccessMutex.wait()
        self.command = nil
        commandAccessMutex.signal()
    }
}
