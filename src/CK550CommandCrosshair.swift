//
//  CK550CommandCrosshair.swift
//  ck550-cli
//
//  Created by Michal Duda on 15/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command.OffEffectOverride {
    struct Crosshair {
        private struct SpeedBytes {
            static func bytes(speed: Speed) -> [uint8] {
                switch speed {
                case .lowest:
                    return [0x17, 0x01]
                case .lower:
                    return [0x0E, 0x01]
                case .middle:
                    return [0x0B, 0x02]
                case .higher:
                    return [0x0A, 0x05]
                case .highest:
                    return [0x04, 0x04]
                }
            }
        }

        enum Speed: Int {
            case lowest = 0, lower, middle, higher, highest
        }

// swiftlint:disable identifier_name
        static var setEffectUNKNOWN_BEFORE_PACKETS: [uint8] {
            return CK550Command.newCommand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
// swiftlint:enable identifier_name

        static func setEffect(speed: Speed, background: RGBColor, key: RGBColor) -> [[uint8]] {
            var result: [[uint8]] = [
                [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x30, 0x00, 0xC1, 0x08, 0x00, 0x00, 0x00, 0xFE, 0xFD, 0xFC, 0xFF, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
            ]

            result[0][24] = UInt8(background.red)
            result[0][25] = UInt8(background.green)
            result[0][26] = UInt8(background.blue)

            result[0][40] = UInt8(key.red)
            result[0][41] = UInt8(key.green)
            result[0][42] = UInt8(key.blue)

            let bytes = SpeedBytes.bytes(speed: speed)
            result[0][36] = bytes[0]
            result[0][46] = bytes[1]

            return result
        }
    }
}
