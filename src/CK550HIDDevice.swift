/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Foundation

class CK550HIDDevice: HIDDevice {
    private var waitForResponseMutex = DispatchSemaphore(value: 0)
    private var commandAccessMutex = DispatchSemaphore(value: 1)
    private var command: CK550HIDDeviceCommand?

    required init(manager: IOHIDManager, device: IOHIDDevice) {
        super.init(manager: manager, device: device)
    }

    override func dataReceived(buffer: [uint8]) {
        commandAccessMutex.wait()
        if let command = self.command {
            if !command.waitsForAnotherResponse() {
//                Terminal.debug(Data(buffer).hexString())
                waitForResponseMutex.signal()
            } else {
                command.addIncomingResponse(buffer)
                if !command.waitsForAnotherResponse() {
                    waitForResponseMutex.signal()
                }
            }
        } else {
//            Terminal.debug(Data(buffer).hexString())
        }
        commandAccessMutex.signal()
    }

    override func write(command: [uint8]) -> Bool {
        return super.write(command: command)
    }

    func write(command: CK550HIDDeviceCommand) {
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
