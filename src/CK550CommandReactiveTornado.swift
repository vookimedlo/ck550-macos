//
//  CK550CommandReactiveTornado.swift
//  ck550-cli
//
//  Created by Michal Duda on 02/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command.OffEffectOverride {
    struct ReactiveTornado {
        private struct ClockwiseSpeedBytes {
            static func bytes(speed: Speed) -> [uint8] {
                switch speed {
                case .lowest:
                    return [0x00, 0xC0]
                case .lower:
                    return [0x01, 0x80]
                case .middle:
                    return [0x02, 0x80]
                case .higher:
                    return [0x03, 0x40]
                case .highest:
                    return [0x04, 0x00]
                }
            }
        }

        private struct CounterclockwiseSpeedBytes {
            static func bytes(speed: Speed) -> [uint8] {
                switch speed {
                case .lowest:
                    return [0xFF, 0x40]
                case .lower:
                    return [0xFE, 0x80]
                case .middle:
                    return [0xFD, 0x80]
                case .higher:
                    return [0xFC, 0xC0]
                case .highest:
                    return [0xFC, 0x00]
                }
            }
        }

        enum Speed: Int {
            case lowest = 0, lower, middle, higher, highest
        }

        enum Direction: Int {
            case clockwise = 0, counterclockwise
        }

// swiftlint:disable identifier_name
        static var setEffectUNKNOWN_BEFORE_PACKETS: [uint8] {
            return CK550Command.newCommand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
// swiftlint:enable identifier_name

        static func setEffect(direction: Direction, speed: Speed) -> [[uint8]] {
            var result: [[uint8]] = [
                [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x83, 0x00, 0xC1, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x30, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
            ]

            switch direction {
            case .clockwise:
                let bytes = ClockwiseSpeedBytes.bytes(speed: speed)
                result[0][22] = bytes[0]
                result[0][25] = bytes[1]
            case .counterclockwise:
                let bytes = CounterclockwiseSpeedBytes.bytes(speed: speed)
                result[0][22] = bytes[0]
                result[0][25] = bytes[1]
            }

            return result
        }
    }
}
