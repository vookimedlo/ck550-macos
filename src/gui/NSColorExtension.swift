//
//  NSColorExtension.swift
//  ck550
//
//  Created by Michal Duda on 26/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

extension NSColor {
    public convenience init(_ color: RGBColor) {
        self.init(red: CGFloat(color.red) / 255,
                  green: CGFloat(color.green) / 255,
                  blue: CGFloat(color.blue) / 255,
                  alpha: 1.0)
    }
}
