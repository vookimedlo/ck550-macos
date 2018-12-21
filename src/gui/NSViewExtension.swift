//
//  NSViewExtension.swift
//  ck550
//
//  Created by Michal Duda on 20/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {
    func findViewController<T: NSViewController>(type: T.Type) -> T? {
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
    private func addBorderSublayer(color: NSColor, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: x, y: y, width: width, height: height)
        self.layer?.addSublayer(layer)
    }
    @discardableResult func addRightBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color, x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height)
        return self
    }
    @discardableResult func addLeftBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color, x: 0, y: 0, width: width, height: self.frame.size.height)
        return self
    }
    @discardableResult func addTopBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color, x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        return self
    }
    @discardableResult func addBottomBorder(color: NSColor, width: CGFloat) -> NSView {
        addBorderSublayer(color: color, x: 0, y: 0, width: self.frame.size.width, height: width)
        return self
    }
}
