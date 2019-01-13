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

/// Creates a valid CK550 keyboard data.
struct CK550Command {
    /// Creates a CK550 data which could be sent to a keyboard.
    ///
    /// - Parameter request: <#request description#>
    /// - Returns: Data which could be sent to a keyboard by a single write HID request.
    /// - Note: CK550 keyboard is an USB Full Speed device, therefore requires data of 64 bytes,
    ///         padded with 0. Padding is also a part of this function.
    static func newCommand(request: [uint8]) -> [uint8] {
        var command = Array.init(repeating: UInt8(0x00), count: 64)
        command.replaceSubrange(Range<Int>(uncheckedBounds: (lower: 0, upper: request.count)), with: request)
        return command
    }
}
