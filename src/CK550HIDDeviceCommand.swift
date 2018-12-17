//
//  CK550HIDDeviceCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 28/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

protocol CK550HIDDeviceCommand {
    func addIncomingResponse(_ packet: [uint8])
    func reportResponseTimeout()
    func reportWriteFailure()
    func nextMessage() -> [uint8]?
    func waitsForAnotherResponse() -> Bool
}
