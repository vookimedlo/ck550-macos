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

class EffectMenuViewController: NSViewController {
    @IBOutlet weak var effectTextField: NSTextField!
    @IBOutlet weak var enablingSegmentedControl: NSSegmentedControl!

    var effect: Effect?
    var effectEnabled: Bool {
        get {
            return enablingSegmentedControl.isSelected(forSegment: 0)
        }
        set(value) {
            enablingSegmentedControl.selectedSegment = value ? 0 : 1
        }
    }

    func setup(effect: Effect) {
        self.effect = effect
        effectTextField.stringValue = self.effect?.name ?? ""
    }

    @IBAction func configurationAction(_ sender: NSButton) {
        var userInfoBuilder = UserInfo()
        userInfoBuilder[.effect] = effect!
        let notification = Notification(name: .CustomEffectConfigure,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }

    @IBAction func enablingToggledAction(_ sender: NSSegmentedControl) {
        var userInfoBuilder = UserInfo()
        userInfoBuilder[.isEnabled] = sender.isSelected(forSegment: 0)
        userInfoBuilder[.effect] = effect!
        let notification = Notification(name: .CustomEffectToggled,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }
}
