//
//  NSButtonExtension.swift
//  ck550
//
//  Created by Michal Duda on 05/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

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
