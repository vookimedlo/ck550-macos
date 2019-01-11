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

extension NSButton {
    func getTextColor() -> NSColor {
        if let color = attributedTitle.attribute(.foregroundColor, at: 0, effectiveRange: nil) {
            if let color = color as? NSColor {
                return color
            }
        }
        return NSColor.black
    }

    @discardableResult func setTextColor(_ color: NSColor) -> Bool {
        var result = false
        if let mutableAttributedTitle = attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor,
                                                value: color,
                                                range: NSRange(location: 0, length: mutableAttributedTitle.length))
            attributedTitle = mutableAttributedTitle
            result = true
        }
        return result
    }

    @objc func textColorChangedAction(_ sender: NSColorPanel) {
        setTextColor(sender.color)
    }

    @objc func backgroundColorChangedAction(_ sender: NSColorPanel) {
        layer?.backgroundColor = sender.color.cgColor
    }
}
