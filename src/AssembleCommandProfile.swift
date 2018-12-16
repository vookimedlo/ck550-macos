//
//  AssembleCommandProfile.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension AssembleCommand {
    static func assembleCommandChangeProfile(profileId: uint8) throws -> CK550HIDCommand {

        let command = CK550HIDCommand()
        command.addOutgoingMessage(CK550Command.setProfileControl)
        command.addOutgoingMessage(CK550Command.setActiveProfile(profileId: profileId))

        return command
    }
}
