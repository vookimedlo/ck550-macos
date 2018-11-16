//
//  CK550CommandEffects.swift
//  ck550-cli
//
//  Created by Michal Duda on 16/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    enum EffectID : uint8 {
        typealias RawValue = uint8
        
        case Static = 0x00
        case Wave = 0x01
        case CrossMode = 0x02
        case SingleKey = 0x03
        case Customization = 0x04
        case Star = 0x05
        case ColorCycle = 0x06
        case Breathing = 0x07
        case Ripple = 0x08
        case Snowing = 0x09
        case ReactivePunch = 0x0a
        case Heartbeat = 0x0b
        case Fireball = 0x0c
        case CircleSpectrum = 0x0d
        case ReactiveTornado = 0x0e
        case WaterRipple = 0x0f
        case GameSnake = 0x10
        case Off = 0xff
    }
    
    static public var getActiveEffects : [uint8] {
        get {
            return newComand(request: [0x52, 0x28])
        }
    }
    static public var setEffectControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x01])
        }
    }
    static private var setEffectTemplate : [uint8] {
        get {
            return newComand(request: [0x51, 0x28])
        }
    }
    static public func setEffect(effectId: EffectID) -> [uint8] {
        var command = setEffectTemplate
        command[4] = effectId.rawValue
        return command
    }
    
}
