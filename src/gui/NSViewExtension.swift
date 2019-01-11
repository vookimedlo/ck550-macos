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

extension NSView {
    func findViewController<T>(type: T.Type) -> T? {
        if let nextResponder = self.nextResponder as? T {
            return nextResponder
        } else if let nextResponder = self.nextResponder as? NSView {
            return nextResponder.findViewController(type: type)
        } else {
            return nil
        }
    }
}

extension NSView {
    // swiftlint:disable identifier_name
    private func addBorderSublayer(color: NSColor, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: x,
                             y: y,
                             width: width,
                             height: height)
        self.layer?.addSublayer(layer)
    }
    // swiftlint:enable identifier_name
    @discardableResult func addRightBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color,
                          x: self.frame.size.width - width,
                          y: 0,
                          width: width,
                          height: self.frame.size.height)
        return self
    }
    @discardableResult func addLeftBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color,
                          x: 0,
                          y: 0,
                          width: width,
                          height: self.frame.size.height)
        return self
    }
    @discardableResult func addTopBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color,
                          x: 0,
                          y: self.frame.size.height - width,
                          width: self.frame.size.width,
                          height: width)
        return self
    }
    @discardableResult func addBottomBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color,
                          x: 0,
                          y: 0,
                          width: self.frame.size.width,
                          height: width)
        return self
    }

    @discardableResult func addBorder(color: NSColor, width: CGFloat) -> NSView {
        addTopBorder(color: color, width: width)
        addBottomBorder(color: color, width: width)
        addLeftBorder(color: color, width: width)
        addRightBorder(color: color, width: width)
        return self
    }
}
