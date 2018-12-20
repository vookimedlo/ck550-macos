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
    func findViewController<T: ViewController>(type: T.Type) -> T? {
        if let nextResponder = self.nextResponder as? T {
            return nextResponder
        } else if let nextResponder = self.nextResponder as? NSView {
            return nextResponder.findViewController(type: type)
        } else {
            return nil
        }
    }
}
