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

class KeyboardInfoViewController: NSViewController, KeyboardInfoHandler {
    @IBOutlet weak var productTextField: NSTextField!
    @IBOutlet weak var firmwareTextField: NSTextField!

    func keyboardInfo(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomKeyboardInfo)
            else {return}
        guard let isPlugged = userInfo[.isPlugged] as? Bool else {return}

        DispatchQueue.main.sync {
            if isPlugged {
                if let fwVersion = userInfo[.fwVersion] as? String {
                    firmwareTextField?.stringValue = fwVersion
                }
                if let product = userInfo[.product] as? String {
                    productTextField?.stringValue = product

                    if let manufacturer = userInfo[.manufacturer] as? String {
                        productTextField?.toolTip = product + " by " + manufacturer
                    }
                }
            } else {
                firmwareTextField?.stringValue = ""
                productTextField?.stringValue = ""
            }
        }
    }
}
