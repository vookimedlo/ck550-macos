//
//  AssembleCommandFirmwareVersion.swift
//  ck550-cli
//
//  Created by Michal Duda on 10/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension AssembleCommand {
    static func assembleCommandFirmwareVersion() throws -> CK550HIDCommand {
        let command = CK550HIDCommand()
        command.addOutgoingMessage(CK550Command.setFirmwareControl)
        command.addOutgoingMessage(CK550Command.getFirmwareVersion)
        
        return command
    }
}
