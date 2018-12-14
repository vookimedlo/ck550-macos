//
//  AssembleCommandCircleSpectrum.swift
//  ck550-cli
//
//  Created by Michal Duda on 14/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension AssembleCommand {
    static func assembleCommandCircleSpectrum(direction: CK550Command.OffEffectCircleSpectrumDirection, speed: CK550Command.OffEffectCircleSpectrumSpeed) throws -> CK550HIDCommand {
        let command = CK550HIDCommand()
        command.addOutgoingMessage(CK550Command.setEffectControl)
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.enableOffEffectModification)
        
        command.addOutgoingMessage(CK550Command.setOffEffectCircleSpectrumUNKNOWN_BEFORE_PACKETS)
        
        let packets = CK550Command.setOffEffectCircleSpectrum(direction: direction, speed: speed)
        for packet in packets {
            command.addOutgoingMessage(packet)
        }
        
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.setFirmwareControl)
        
        return command
    }
}
