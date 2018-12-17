//
//  AssembleCommandWave.swift
//  ck550-cli
//
//  Created by Michal Duda on 10/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension AssembleCommand {
    static func assembleCommandWave(color: RGBColor, direction: CK550Command.OffEffectOverride.Wave.Direction, speed: CK550Command.OffEffectOverride.Wave.Speed) throws -> CK550HIDCommand {
        let command = CK550HIDCommand()
        command.addOutgoingMessage(CK550Command.setEffectControl)
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .off))
        command.addOutgoingMessage(CK550Command.enableOffEffectModification)

        command.addOutgoingMessage(CK550Command.OffEffectOverride.Wave.setEffectUNKNOWN_BEFORE_PACKETS)

        let packets = CK550Command.OffEffectOverride.Wave.setEffect(color: color, direction: direction, speed: speed)
        for packet in packets {
            command.addOutgoingMessage(packet)
        }

        command.addOutgoingMessage(CK550Command.setEffect(effectId: .off))
        command.addOutgoingMessage(CK550Command.setFirmwareControl)

        return command
    }
}
