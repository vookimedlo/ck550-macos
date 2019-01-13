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

/// The device side of the `CK550HIDCommand`.
protocol CK550HIDDeviceCommand {
    /// Appends incoming keyboard data.
    ///
    /// - Parameter packet: Incoming CK550 keyboard data.
    func addIncomingResponse(_ packet: [uint8])

    /// Sets the command result to the `CK550HIDCommand.Result.responseTimedout`.
    func reportResponseTimeout()

    /// Sets the command result to the `CK550HIDCommand.Result.writeFailed`.
    func reportWriteFailure()

    /// Provides the next data, which shall be sent to the CK550 keyboard.
    ///
    /// - Returns: CK550 data. Nil if no unsent data is available.
    func nextMessage() -> [uint8]?

    /// Checks if additional data is expected from the keyboard.
    ///
    /// - Returns: True if command expects another response from the keyboard. False otherwise.
    func waitsForAnotherResponse() -> Bool
}
