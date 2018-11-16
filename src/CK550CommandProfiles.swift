//
//  CK550CommandProfiles.swift
//  ck550-cli
//
//  Created by Michal Duda on 16/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    static var getActiveProfile : [uint8] {
        get {
            return newComand(request: [0x52, 0x00])
        }
    }
    static var saveCurrentProfile : [uint8] {
        get {
            return newComand(request: [0x50, 0x55])
        }
    }
    static var setProfileControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x03])
        }
    }
    
    static private var setActiveProfileTemplate : [uint8] {
        get {
            return newComand(request: [0x51, 0x00])
        }
    }
    static func setActiveProfile(profileId: uint8) -> [uint8] {
        var command = setActiveProfileTemplate
        command[4] = profileId
        return command
    }
}
