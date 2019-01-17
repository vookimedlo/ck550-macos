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
import Commandant
import Result

public struct AboutCommand: CommandProtocol {
    public let verb = "about"
    public let function = "About ck550-cli..."

    public func run(_ options: NoOptions<CLIError>) -> Result<(), CLIError> {
        let bundleVersion = Bundle.bundleVersion()
        let version = "Version:  \(bundleVersion.version) build \(bundleVersion.build)"
        let license = "License:  MIT"
        let author = "Author:   Michal Duda"
        let contact = "Contact:  github@vookimedlo.cz"
        let homepage = "Homepage: https://github.com/vookimedlo/ck550-macos"
        Terminal.general(version)
        Terminal.general(license)
        Terminal.general(author)
        Terminal.general(contact)
        Terminal.general(homepage)
        return .success(())
    }
}
