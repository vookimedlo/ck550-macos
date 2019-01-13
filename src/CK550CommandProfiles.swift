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

// MARK: - CK550 profile related data.
extension CK550Command {
    /// Creates a command to get an actually used profile by keyboard.
    static var getActiveProfile: [uint8] {
        return newCommand(request: [0x52, 0x00])
    }

    /// Saves changes in a currently used profile.
    static var saveCurrentProfile: [uint8] {
        return newCommand(request: [0x50, 0x55])
    }

    /// Creates a command to enable profile commands.
    static var setProfileControl: [uint8] {
        return newCommand(request: [0x41, 0x03])
    }

    static private var setActiveProfileTemplate: [uint8] {
        return newCommand(request: [0x51, 0x00])
    }

    /// Creates a command to set an actually used profile by keyboard.
    ///
    /// - Parameter profileId: Profile to be used.
    /// - Returns: Requested CK550 data.
    static func setActiveProfile(profileId: uint8) -> [uint8] {
        var command = setActiveProfileTemplate
        command[4] = profileId
        return command
    }
}
