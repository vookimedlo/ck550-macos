//
//  CK550CommandFirmware.swift
//  ck550-cli
//
//  Created by Michal Duda on 17/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    static var getFirmwareVersion: [uint8] {
        return newCommand(request: [0x12, 0x20])
    }

    static var setFirmwareControl: [uint8] {
        return newCommand(request: [0x41, 0x00])
    }
}
