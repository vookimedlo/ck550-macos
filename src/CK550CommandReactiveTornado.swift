//
//  CK550CommandReactiveTornado.swift
//  ck550-cli
//
//  Created by Michal Duda on 02/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    
    private struct OffEffectReactiveTornadoClockwiseSpeedBytes {
        static func bytes(speed: OffEffectReactiveTornadoSpeed) -> [uint8] {
            switch speed {
            case .Lowest:
                return [0x00, 0xC0]
            case .Lower:
                return [0x01, 0x80]
            case .Middle:
                return [0x02, 0x80]
            case .Higher:
                return [0x03, 0x40]
            case .Highest:
                return [0x04, 0x00]
            }
        }
    }
    
    private struct OffEffectReactiveTornadoCounterclockwiseSpeedBytes {
        static func bytes(speed: OffEffectReactiveTornadoSpeed) -> [uint8] {
            switch speed {
            case .Lowest:
                return [0xFF, 0x40]
            case .Lower:
                return [0xFE, 0x80]
            case .Middle:
                return [0xFD, 0x80]
            case .Higher:
                return [0xFC, 0xC0]
            case .Highest:
                return [0xFC, 0x00]
            }
        }
    }
    
    enum OffEffectReactiveTornadoSpeed : uint8 {
        typealias RawValue = uint8
        case Lowest = 0x00
        case Lower = 0x01
        case Middle = 0x02
        case Higher = 0x03
        case Highest = 0x04
    }
    
    enum OffEffectReactiveTornadoDirection {
        case Clockwise, Counterclockwise
    }
    
    static var setOffEffectReactiveTornadoUNKNOWN_BEFORE_PACKETS: [uint8] {
        get {
            return newComand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }
    
    static func setOffEffectReactiveTornado(direction: OffEffectReactiveTornadoDirection, speed: OffEffectReactiveTornadoSpeed) -> [[uint8]] {
        var result: [[uint8]] = [
            [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x83, 0x00, 0xC1, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x30, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        ]
        
        switch direction {
        case .Clockwise:
            let bytes = OffEffectReactiveTornadoClockwiseSpeedBytes.bytes(speed: speed)
            result[0][22] = bytes[0]
            result[0][25] = bytes[1]
        case .Counterclockwise:
            let bytes = OffEffectReactiveTornadoCounterclockwiseSpeedBytes.bytes(speed: speed)
            result[0][22] = bytes[0]
            result[0][25] = bytes[1]
        }

        return result
    }
}
