//
//  CK550HIDClientCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 28/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550HIDCommand {
    enum Result {
        case ok
        case writeFailed
        case responseFailed
        case responseTimedout
        case notProcessed
    }
}

protocol CK550HIDClientCommand {
    var responses: Queue<[uint8]> { get }
    var processedMessage: [uint8]? { get }
    var processedResponse: [uint8]? { get }
    var processedExpectedResponse: [uint8]? { get }
    var result: CK550HIDCommand.Result { get }

    func addOutgoingMessage(_ packet: [uint8], createExpectedResponse: Bool) -> Void
    func addExpectedResponse(_ packet: [uint8]) -> Void
}
