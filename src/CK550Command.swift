//
//  CK550Command.swift
//  ck550
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

struct CK550Command {
    static public var getActiveProfile : [uint8] {
        get {
            return newComand(request: [0x52, 0x00])
        }
    }
    static private var setActiveProfileTemplate : [uint8] {
        get {
            return newComand(request: [0x51, 0x00])
        }
    }
    static public var saveCurrentProfile : [uint8] {
        get {
            return newComand(request: [0x50, 0x55])
        }
    }
    static public var getActiveEffects : [uint8] {
        get {
            return newComand(request: [0x52, 0x28])
        }
    }
    static public var setFirmwareControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x00])
        }
    }
    static public var setEffectControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x01])
        }
    }
    static public var setManualControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x02])
        }
    }
    static public var setProfileControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x03])
        }
    }
    
    static public var turnLEDsOff : [uint8] {
        get {
            return newComand(request: [0xC0, 0x00])
        }
    }
    static private var setLEDsColorTemplate : [uint8] {
        get {
            return newComand(request: [0xC0, 0x00])
        }
    }
    static public var getCustomRGBMapping : [uint8] {
        get {
            return newComand(request: [0x52, 0xa8])
        }
    }
    
    static private func newComand(request: [uint8]) -> [uint8] {
        var command = Array.init(repeating: UInt8(0x00), count: 64)
        command.replaceSubrange(Range<Int>(uncheckedBounds: (lower: 0, upper: request.count)), with: request)
        return command
    }
    
    static public func setActiveProfile(profileId: uint8) -> [uint8] {
        var command = setActiveProfileTemplate
        command[4] = profileId
        return command
    }
    
    static public func setLEDsColor(red: uint8, green: uint8, blue: uint8) -> [uint8] {
        var command = setLEDsColorTemplate
        command[4] = red
        command[5] = green
        command[6] = blue
        return command
    }
}
