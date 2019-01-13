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

extension CK550HIDCommand {
    /// CK550 command result
    ///
    /// - succeeded: All command data was written and all expected responses were received.
    /// - writeFailed: Write failed.
    /// - responseFailed: Command data was written, but not all expected responses were received.
    /// - responseTimedout: Command data was written, but expected responses were not received in time.
    /// - notProcessed: Command data hasn't been written yet.
    enum Result {
        case succeeded
        case writeFailed
        case responseFailed
        case responseTimedout
        case notProcessed
    }
}

/// The client side of the `CK550HIDCommand`.
protocol CK550HIDClientCommand {
    /// Data coming from a keyboard.
    var responses: Queue<[uint8]> { get }

    /// Data sent to a keyboard.
    var processedMessage: [uint8]? { get }

    /// Keyboard data, which were checked for correctness.
    var processedResponse: [uint8]? { get }

    /// Expected data provided before a command execution,
    /// which was already used for a correctness check.
    var processedExpectedResponse: [uint8]? { get }

    /// Command result.
    var result: CK550HIDCommand.Result { get }

    /// Appends CK550 data, which will be sent to the CK550 keyboard.
    ///
    /// - Parameters:
    ///   - packet: CK550 data.
    ///   - createExpectedResponse: If true, expected response is derived from the outgoing `packet`.
    ///                             If false, `packet` is just appended to other outgoing data.
    func addOutgoingMessage(_ packet: [uint8], createExpectedResponse: Bool)

    /// Appends CK550 data, which are expected to be received from CK550 keyboard.
    ///
    /// - Parameter packet: CK550 data.
    func addExpectedResponse(_ packet: [uint8])
}
