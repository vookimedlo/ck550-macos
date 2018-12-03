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
        
        case Static          = 0x00 // CK550CommandStatic
        case Wave            = 0x01 // CK550CommandWave
        case CrossMode       = 0x02 //
        case SingleKey       = 0x03 // CK550CommandSingleKey
        case Customization   = 0x04 // CK550CommandCustomization
        case Star            = 0x05 // CK550CommandStars
        case ColorCycle      = 0x06 // CK550CommandColorCycle
        case Breathing       = 0x07 //
        case Ripple          = 0x08 // CK550CommandRipple
        case Snowing         = 0x09 // CK550CommandSnowing
        case ReactivePunch   = 0x0a //
        case Heartbeat       = 0x0b //
        case Fireball        = 0x0c //
        case CircleSpectrum  = 0x0d // CK550CommandCircleSpectrum
        case ReactiveTornado = 0x0e // CK550CommandReactiveTornado
        case WaterRipple     = 0x0f //
        case GameSnake       = 0x10 //
        case Off             = 0xff // CK550CommandOff
    }
    
    static var getActiveEffects : [uint8] {
        get {
            return newComand(request: [0x52, 0x28])
        }
    }
    static var setEffectControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x01])
        }
    }
    static private var setEffectTemplate : [uint8] {
        get {
            return newComand(request: [0x51, 0x28])
        }
    }
    static func setEffect(effectId: EffectID) -> [uint8] {
        var command = setEffectTemplate
        command[4] = effectId.rawValue
        return command
    }
    static var enableOffEffectModification : [uint8] {
        get {
            return newComand(request: [0x41, 0x80])
        }
    }
}
