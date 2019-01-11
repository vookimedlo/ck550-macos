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
