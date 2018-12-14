//
//  CommonArguments.swift
//  ck550-cli-dev
//
//  Created by Michal Duda on 13/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant

public enum SpeedArgument: String, ArgumentProtocol, CustomStringConvertible {
    case highest = "highest"
    case higher  = "higher"
    case middle  = "middle"
    case lower   = "lower"
    case lowest  = "lowest"
    
    public var description: String {
        return self.rawValue
    }
    
    public static let name = "speed"
    
    public static func from(string: String) -> SpeedArgument? {
        return self.init(rawValue: string.lowercased())
    }
}

public func createRGBColor(_ array: [Int]) -> RGBColor? {
    return array.isEmpty ? nil : RGBColor(red: UInt16(array[0]), green: UInt16(array[1]), blue: UInt16(array[2]))
}
