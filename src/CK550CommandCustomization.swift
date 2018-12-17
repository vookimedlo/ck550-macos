//
//  CK550CommandEffectsCustomization.swift
//  ck550-cli
//
//  Created by Michal Duda on 21/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command.OffEffectOverride {
    struct Customization {
        fileprivate static func initializePacket(packetId: Int) -> [uint8] {
            switch packetId {
            case 0:
                return CK550Command.newCommand(request: [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x80, 0x01, 0x00, 0xC1, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF])
            default:
                var command = CK550Command.newCommand(request: [0x56, 0x83, 0x00])
                command[2] = UInt8(packetId)
                return command
            }
        }

        // swiftlint:disable identifier_name
        static var setEffectUNKNOWN_BEFORE_PACKETS: [uint8] {
            return CK550Command.newCommand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0xBB, 0xBB, 0xBB, 0xBB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }

        static var setEffectUNKNOWN_AFTER_PACKETS: [uint8] {
            return CK550Command.newCommand(request: [0x40, 0x63])
        }
        // swiftlint:enable identifier_name

    }

    class CK550OffEffectCustomizationKeys<LAYOUT: CK550OffEffectCustomizationLayout> {
        var layout: LAYOUT

        init(layout: LAYOUT) {
            self.layout = layout
        }

        public func packets() -> [[uint8]] {
            let sharedColorDataOffset = 0x3F
            var packets = [[uint8]]()

            for packetId in (0...7) {
                var packet = CK550Command.OffEffectOverride.Customization.initializePacket(packetId: packetId)

                // Shared color data from the previous packet
                if let key = layout.key(packet: packetId - 1, offset: sharedColorDataOffset) {
                    let color = layout.color(key: key)
                    packet[0x04] = UInt8(color.green)
                    packet[0x05] = UInt8(color.blue)
                }

                for offsetId in (0...19) {
                    let offset = 0x06 + 3 * offsetId
                    if let key = layout.key(packet: packetId, offset: offset) {
                        let color = layout.color(key: key)
                        packet[offset] = UInt8(color.red)
                        if offset == sharedColorDataOffset {
                            continue
                        }
                        packet[offset + 1] = UInt8(color.green)
                        packet[offset + 2] = UInt8(color.blue)
                    }
                }
                packets.append(packet)
            }

            return packets
        }
    }
}
