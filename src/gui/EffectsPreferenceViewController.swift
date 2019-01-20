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
import Cocoa
import SwiftyJSON

class EffectsPreferenceViewController: NSViewController, PreferenceViewController {
    var settings: JSON {
        get {
            // No implementation, because no preferences are not available for given effect
            return [:]
        }
        // swiftlint:disable unused_setter_value
        set {
            // No implementation, because no preferences are not available for given effect
        }
        // swiftlint:enable unused_setter_value
    }

    func setup() {
        // No implementation, because no preferences are not available for given effect
    }

    func deactivated() {
        // No implementation, because no preferences are not available for given effect
    }

    @IBAction func restoreDefaultEffectsSettingsAction(_ sender: NSButton) {
        let notification = Notification(name: .CustomEffectDefaultConfiguration,
                                        object: self,
                                        userInfo: nil)
        NotificationCenter.default.post(notification)
    }
}
