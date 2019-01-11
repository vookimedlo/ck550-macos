/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

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
