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

extension CK550Command {
    struct OffEffectOverride {
        struct Breathing {
            private struct SpeedBytes {
                static func bytes(speed: Speed) -> [uint8] {
                    switch speed {
                    case .lowest:
                        return [0x08, 0x01]
                    case .lower:
                        return [0x0A, 0x02]
                    case .middle:
                        return [0x0C, 0x04]
                    case .higher:
                        return [0x07, 0x04]
                    case .highest:
                        return [0x09, 0x09]
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

            static func setEffect(speed: Speed, color: RGBColor? = nil) -> [[uint8]] {
                var result: [[uint8]] = [
                    [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x30, 0x00, 0xC1, 0x08, 0x00, 0x00, 0x00, 0xFE, 0xFD, 0xFC, 0xFF, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
                ]

                if let color = color {
                    result[0][16] = UInt8(color.red)
                    result[0][17] = UInt8(color.green)
                    result[0][18] = UInt8(color.blue)
                    result[0][20] = 0x01
                } else {
                    result[0][16] = 0xFE
                    result[0][17] = 0xFD
                    result[0][18] = 0xFC
                    result[0][20] = 0x03
                }

                let bytes = SpeedBytes.bytes(speed: speed)
                result[0][12] = bytes[0]
                result[0][22] = bytes[1]

                return result
            }
        }
    }
}
