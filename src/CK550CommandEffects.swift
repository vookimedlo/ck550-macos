//
//  CK550CommandEffects.swift
//  ck550-cli
//
//  Created by Michal Duda on 16/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    enum EffectID: uint8 {
        typealias RawValue = uint8

        case staticKeys = 0x00 // CK550CommandStatic
        case wave = 0x01 // CK550CommandWave
        case crossMode = 0x02 // CK550CommandCrosshair
        case singleKey = 0x03 // CK550CommandSingleKey
        case customization = 0x04 // CK550CommandCustomization
        case star = 0x05 // CK550CommandStars
        case colorCycle = 0x06 // CK550CommandColorCycle
        case breathing = 0x07 // CK550CommandBreathing
        case ripple = 0x08 // CK550CommandRipple
        case snowing = 0x09 // CK550CommandSnowing
        case reactivePunch = 0x0a // CK550CommandReactivePunch
        case heartbeat = 0x0b // CK550CommandHeartbeat
        case fireball = 0x0c // CK550CommandFireball
        case circleSpectrum = 0x0d // CK550CommandCircleSpectrum
        case reactiveTornado = 0x0e // CK550CommandReactiveTornado
        case waterRipple = 0x0f // CK550CommandWaterRipple
        case gameSnake = 0x10 //
        case off = 0xff // CK550CommandOff
    }

    static var getActiveEffects: [uint8] {
        return newCommand(request: [0x52, 0x28])
    }

    static var setEffectControl: [uint8] {
        return newCommand(request: [0x41, 0x01])
    }

    static private var setEffectTemplate: [uint8] {
        return newCommand(request: [0x51, 0x28])
    }

    static func setEffect(effectId: EffectID) -> [uint8] {
        var command = setEffectTemplate
        command[4] = effectId.rawValue
        return command
    }

    static var enableOffEffectModification: [uint8] {
        return newCommand(request: [0x41, 0x80])
    }
}
