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

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        guard let name: String = dictionary["CFBundleName"] as? String else {
            return ""
        }
        return name
    }

    static func bundleVersion() -> (version: String, build: String) {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ("", "")
        }
        guard let version = dictionary["CFBundleShortVersionString"]  as? String else {
            return ("", "")
        }
        guard let build = dictionary[kCFBundleVersionKey as String] as? String else {
            return (version, "")
        }
        return (version, build)
    }

    static func isUpdaterEnabled() -> Bool {
        guard let dictionary = Bundle.main.infoDictionary else {
            return false
        }
        guard let isEnabled: Bool = dictionary["UpdaterEnabled"] as? Bool else {
            return false
        }
        return isEnabled
    }
}
