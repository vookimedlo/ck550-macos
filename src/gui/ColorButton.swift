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

class ColorButton: NSButton {
    private let colorPopover = ColorPopover()
    private var colorArea: CALayer?
    private var internalColor = NSColor.black.usingColorSpace(.genericRGB)!
    var color: NSColor {
        get { return internalColor }
        set {
            colorArea?.borderColor = newValue.cgColor
            internalColor = newValue.usingColorSpace(.genericRGB)!
        }
    }

    override func viewWillDraw() {
        guard colorArea != nil else {
            target = self
            action = #selector(clickedAction(_:))
            border(color: NSColor.lightGray, width: 3)
            colorArea = borderSublayer(color: NSColor.black.usingColorSpace(.genericRGB)!,
                                       x: xOffset + 3,
                                       y: yOffset + 3,
                                       width: self.frame.size.width - 2 * xOffset - 6,
                                       height: self.frame.size.height - 2 * yOffset - 6)
            colorArea?.borderColor = internalColor.cgColor
            return
        }
    }

    @objc func clickedAction(_ sender: Any?) {
        colorPopover.setAction(target: self,
                               selector: #selector(colorChangedAction(_:)))
        colorPopover.show(parent: self, initialColor: color)
    }

    @objc func colorChangedAction(_ sender: NSColorPanel) {
        colorArea?.borderColor = sender.color.cgColor
        internalColor = sender.color.usingColorSpace(.genericRGB)!
    }
}

extension ColorButton {
    internal var xOffset: CGFloat { return 0 }
    internal var yOffset: CGFloat { return 2 }

    // swiftlint:disable identifier_name
    @discardableResult internal func borderSublayer(color: NSColor, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CALayer {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: x,
                             y: y,
                             width: width,
                             height: height)
        self.layer?.addSublayer(layer)
        return layer
    }
    // swiftlint:enable identifier_name
    @discardableResult internal func rightBorder(color: NSColor, width: CGFloat) -> NSView {
        borderSublayer(color: color,
                          x: self.frame.size.width - width - xOffset,
                          y: yOffset,
                          width: width,
                          height: self.frame.size.height - 2 * yOffset)
        return self
    }
    @discardableResult internal func leftBorder(color: NSColor, width: CGFloat) -> NSView {
        borderSublayer(color: color,
                          x: xOffset,
                          y: yOffset,
                          width: width,
                          height: self.frame.size.height - 2 * yOffset)
        return self
    }
    @discardableResult internal func bottomBorder(color: NSColor, width: CGFloat) -> NSView {
        borderSublayer(color: color,
                          x: xOffset,
                          y: self.frame.size.height - width - yOffset,
                          width: self.frame.size.width - 2 * xOffset,
                          height: width)
        return self
    }
    @discardableResult internal func topBorder(color: NSColor, width: CGFloat) -> NSView {
        borderSublayer(color: color,
                          x: xOffset,
                          y: yOffset,
                          width: self.frame.size.width - 2 * xOffset,
                          height: width)
        return self
    }
    @discardableResult internal func border(color: NSColor, width: CGFloat) -> NSView {
        topBorder(color: color, width: width)
        bottomBorder(color: color, width: width)
        leftBorder(color: color, width: width)
        rightBorder(color: color, width: width)
        return self
    }
}
