//
//  CK550HIDCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 28/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CK550HIDCommand: CK550HIDDeviceCommand, CK550HIDClientCommand {
    private var messages: Queue<[uint8]> = Queue<[uint8]>()
    private var expectedResponses: Queue<[uint8]> = Queue<[uint8]>()

    private(set) var responses: Queue<[uint8]> = Queue<[uint8]>()
    private(set) var processedMessage: [uint8]?
    private(set) var processedResponse: [uint8]?
    private(set) var processedExpectedResponse: [uint8]?
    private(set) var result: Result = .notProcessed

    func addOutgoingMessage(_ packet: [uint8], createExpectedResponse: Bool = true) {
        messages.enqueue(packet)
        if createExpectedResponse {
            addExpectedResponse([uint8](packet.prefix(2)))
        }
    }

    func addExpectedResponse(_ packet: [uint8]) {
        expectedResponses.enqueue(packet)
    }

    func addIncomingResponse(_ packet: [uint8]) {
        processedResponse = packet
        if let processedExpectedResponse = expectedResponses.dequeue() {
            if packet.starts(with: processedExpectedResponse) {
                responses.enqueue(packet)
                if expectedResponses.count() == 0 {
                    result = .succeeded
                }
            } else {
                self.processedExpectedResponse = processedExpectedResponse
                result = .responseFailed
            }
        }
    }

    func reportResponseTimeout() {
        result = .responseTimedout
    }

    func reportWriteFailure() {
        result = .writeFailed
    }

    func nextMessage() -> [uint8]? {
        processedMessage = messages.dequeue()
        if processedMessage == nil && !waitsForAnotherResponse() {
            result = .succeeded
        }
        return processedMessage
    }

    func waitsForAnotherResponse() -> Bool {
        return expectedResponses.count() > 0 && result != .responseFailed
    }
}
