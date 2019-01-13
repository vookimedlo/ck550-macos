/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Foundation

// MARK: - CK550 effect related data.
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

    /// Creates a command to get enabled effects.
    static var getActiveEffects: [uint8] {
        return newCommand(request: [0x52, 0x28])
    }

    /// Creates a command to enable effects commands.
    static var setEffectControl: [uint8] {
        return newCommand(request: [0x41, 0x01])
    }

    static private var setEffectTemplate: [uint8] {
        return newCommand(request: [0x51, 0x28])
    }

    /// Creates a command to set a keyboard effect.
    ///
    /// - Parameter effectId: Effect to set.
    /// - Returns: Requested CK550 data.
    /// - SeeAlso: `CK550Command.EffectID`
    static func setEffect(effectId: EffectID) -> [uint8] {
        var command = setEffectTemplate
        command[4] = effectId.rawValue
        return command
    }

    /// Creates a command to enable an *Off* effect redefinition.
    static var enableOffEffectModification: [uint8] {
        return newCommand(request: [0x41, 0x80])
    }
}
