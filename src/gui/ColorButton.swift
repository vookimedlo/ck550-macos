//
//  ColorButton.swift
//  ck550
//
//  Created by Michal Duda on 08/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

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
        colorPopover.colorPanel.color = color
        colorPopover.setAction(target: self,
                               selector: #selector(colorChangedAction(_:)))
        colorPopover.show(parent: self)
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
