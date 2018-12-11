//
//  Terminal.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import PrettyColors

class Terminal {
    // ‼️💬⚠️ℹ️
    
    static public var colorError: PrettyColors.Color.Named.Color?     = .red
    static public var colorWarn: PrettyColors.Color.Named.Color?      = .yellow
    static public var colorOK: PrettyColors.Color.Named.Color?        = .green
    static public var colorImportant: PrettyColors.Color.Named.Color? = .magenta
    static public var colorGeneral: PrettyColors.Color.Named.Color?   = nil
    
    static private func print(_ items: [Any], separator: String = " ", terminator: String = "\n", color: PrettyColors.Color.Named.Color?) -> Void {
        var output: String = ""
        
        // Splatting is not in the language yet, so the passed array is processed 'one by one'
        // https://bugs.swift.org/browse/SR-128
        // Swift.print(items, separator: separator, terminator: terminator, to: &output)
        
        var index = 0
        for item in items {
            Swift.print(item, terminator: "", to: &output)
            if index < items.count - 1 {
                Swift.print(separator, terminator: "", to: &output)
                index += 1
            }
        }
        Swift.print(terminator, terminator: "", to: &output)

        #if DEBUG
        Swift.print(output, separator: "", terminator: "")
        #else
        if let color = color {
            let coloredString = Color.Wrap(foreground: color).wrap(output)
            Swift.print(coloredString, separator: "", terminator: "")
        }
        else {
            Swift.print(output, separator: "", terminator: "")
        }
        #endif
    }
    
    static func general(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
        print(items, separator: separator, terminator: terminator, color: colorGeneral)
    }
    
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
        print(items, separator: separator, terminator: terminator, color: colorError)
    }
    
    static func warn(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
        print(items, separator: separator, terminator: terminator, color: colorWarn)
    }
    
    static func ok(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
        print(items, separator: separator, terminator: terminator, color: colorOK)
    }
    
    static func important(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
        print(items, separator: separator, terminator: terminator, color: colorImportant)
    }
}
