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

/// Represents a CK550 control HID device.
class CK550HIDDevice: HIDDevice {
    /// Signalizes if a waiting condition of currently processed `command` has already occured.
    private var waitForResponseEvent = DispatchSemaphore(value: 0)

    /// Guards access to the `command`.
    private var commandAccessMutex = DispatchSemaphore(value: 1)

    /// CK550 command, which is currently processed.
    private var command: CK550HIDDeviceCommand?

    /// Creates a device.
    ///
    /// - Parameters:
    ///   - manager: Instance of a IOHIDManager, which was responsible for a device enumeration.
    ///   - device: Underlying device reported by the 'manager'.
    required init(manager: IOHIDManager, device: IOHIDDevice) {
        super.init(manager: manager, device: device)
    }

    /// A callback providing data received from the device.
    ///
    /// - Parameter buffer: Bytes received from the device.
    /// - note: Passes incoming data to the currently processed `CK550HIDDeviceCommand`.
    ///         If no command is processed right now, incoming data are silently discarded.
    override func dataReceived(buffer: [uint8]) {
        commandAccessMutex.wait()
        if let command = self.command {
            if !command.waitsForAnotherResponse() {
//                Terminal.debug(Data(buffer).hexString())
                waitForResponseEvent.signal()
            } else {
                command.addIncomingResponse(buffer)
                if !command.waitsForAnotherResponse() {
                    waitForResponseEvent.signal()
                }
            }
        } else {
//            Terminal.debug(Data(buffer).hexString())
        }
        commandAccessMutex.signal()
    }

    /// Sends a CK550 `command` to the device.
    ///
    /// - Parameters:
    ///   - command: CK550 command.
    ///   - timeoutForResponse: Timeout value defining how much time
    ///                         it shall wait for required responses.
    /// - Note: Waiting for incoming responses is fully driven by the `command` itself.
    func write(command: CK550HIDDeviceCommand, timeoutForResponse: Int = 500) {
        let shallWait = command.waitsForAnotherResponse()
        if shallWait {
            waitForResponseEvent = DispatchSemaphore(value: 0)
            commandAccessMutex.wait()
            self.command = command
            commandAccessMutex.signal()
        }
        var packet = command.nextMessage()
        while packet != nil {
            if !write(buffer: packet!) {
                commandAccessMutex.wait()
                command.reportWriteFailure()
                self.command = nil
                commandAccessMutex.signal()
                return
            }
            packet = command.nextMessage()
        }

        if shallWait {
            if .timedOut == waitForResponseEvent.wait(timeout: .now() + .milliseconds(timeoutForResponse)) {
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
