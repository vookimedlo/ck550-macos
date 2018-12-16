//
//  AssembleCommandHeartbeat.swift
//  ck550-cli
//
//  Created by Michal Duda on 15/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension AssembleCommand {
    static func assembleCommandHeartbeat(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectHeartbeatSpeed) throws -> CK550HIDCommand {
        let command = CK550HIDCommand()
        command.addOutgoingMessage(CK550Command.setEffectControl)
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.enableOffEffectModification)

        command.addOutgoingMessage(CK550Command.setOffEffectHeartbeatUNKNOWN_BEFORE_PACKETS)

        let packets = CK550Command.setOffEffectHeartbeat(background: background, key: key, speed: speed)
        for packet in packets {
            command.addOutgoingMessage(packet)
        }

        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.setFirmwareControl)

        return command
    }
}
